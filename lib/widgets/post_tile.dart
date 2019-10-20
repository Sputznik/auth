import 'dart:ui';
import 'dart:io';
import 'package:auth/editor_view.dart';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../io/stores.dart';
import "../postdata.dart";
import 'post_options.dart';
import 'image_picker_dialog.dart';

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

  ImageProvider buildFeaturedImage(BuildContext context) {
    ImageProvider image;
    image = AssetImage('assets/default.png');
    if (post.featuredImage != null) {
      image = FileImage(post.getFeaturedImage());
    }
    return image;
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
                        image: buildFeaturedImage(context), fit: BoxFit.cover)),
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
                child: PostOptionsMenu(onSelectedOption),
              ),
            ],
          )
        ],
      ),
    );
  }

  void onSelectedOption(selectedItem) {
    switch (selectedItem) {
      case 'edit':
        openEditor();
        break;
      case "set-featured":
        showDialog(
                context: context,
                builder: (BuildContext context) => ImagePickerDialog())
            .then((newImage) {
          setState(() {
            post.setFeaturedImage(newImage);
          });
        });
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
