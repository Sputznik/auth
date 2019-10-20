import 'dart:ui';
import 'dart:io';
import 'package:auth/editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'io/stores.dart';
import "postdata.dart";

class PostTile extends StatefulWidget {
  final PostData post;

  final PostsStore store;

  PostTile(this.post, this.store);

  @override
  _PostTileState createState() => _PostTileState(this.post, this.store);
}

class _PostTileState extends State<PostTile> {

  PostData post;

  final PostsStore store;

  _PostTileState(this.post, this.store);

  Widget build(BuildContext context) {
    if (post != null) {
      return buildItem(context);
    }
    return SizedBox.shrink();
  }

  ImageProvider buildFeaturedImageWidget(BuildContext context) {
    ImageProvider image;
    image = AssetImage('assets/default.png');
    if (post.featuredImage != null) {
      image = FileImage(post.getFeaturedImage());
    }
    return image;
  }

  buildFeaturedImage(post, context) {
    var featuredDialog = AlertDialog(
      title: Text('Choose An Image'),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: Container(
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            InkWell(
              child: Text("Take photo"),
              onTap: () {
                Navigator.of(context).pop();
                openCamera().then((newImage) {
                  saveSelectedImageAsFeatured(post, newImage);
                });
              },
            ),
            SizedBox(height: 20.0),
            InkWell(
              child: Text("Choose from gallery"),
              onTap: () {
                Navigator.of(context).pop();
                openGallery().then((newImage) {
                  saveSelectedImageAsFeatured(post, newImage);
                });
              },
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => featuredDialog);
  }

  Future<File> openGallery() async =>
      await ImagePicker.pickImage(source: ImageSource.gallery);

  Future<File> openCamera() async =>
      await ImagePicker.pickImage(source: ImageSource.camera);

  saveSelectedImageAsFeatured(post, newImage) {
    post.setFeaturedImage(newImage);
  }

  Widget buildItem(context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: buildFeaturedImageWidget(context),
                        fit: BoxFit.cover)),
              ),
              Container(
                width: 195,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.getTitle().toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      post.getContent().toPlainText().replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20.0),
                    Text(post.getCreatedAt(),
                        style: TextStyle(fontWeight: FontWeight.w300))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                width: 30,
                child: PopupMenuButton(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'set-featured',
                      child: Text('Set Featured Image'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                    PopupMenuItem<String>(
                      value: 'publish',
                      child: Text('Publish'),
                    ),
                  ],
                  onSelected: (selectedItem) {
                    switch (selectedItem) {
                      case 'edit':
                        openEditor();
                        break;
                      case "set-featured":
                        //setFeaturedImage(post, context);
                        break;
                      case "delete":
                        setState(() {
                          post = null;
                        });
                        store.delete(post.id);
                        break;
                      case "publish":
                        /*
                         * OPERATION TO SEND TO API AND GET IT PUBLISHED USING WP API
                         */
                        break;
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /*
  * OPENS THE EDITOR
  * WAITS FOR THE POP EVENT
  * SAVES THE NEW POST RECEIVED & REBUILDS THE UI ONLY IF THE UPDATED POST HAS CHANGED
  */
  void openEditor() async {

    // TAKE A SNAPSHOT OF THE DATA AS STRING BEFORE IT IS SENT
    String oldPostData = post.toString();

    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage(post)))
        .then((newPost) {
      if (newPost.toString() != oldPostData) {

        // SAVE TO FILE
        store.saveAsPost(post);

        // REBUILD THE UI
        setState(() {
          post = newPost;
        });
      }
    });
  }
}
