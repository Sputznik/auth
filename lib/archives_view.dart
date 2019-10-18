import 'dart:ui';
import 'dart:io';
import 'package:auth/editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'io/stores.dart';
import "postdata.dart";

class Archives extends StatefulWidget {
  @override
  _ArchivesState createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  List data = [];

  PostsStore postsStore;

  Map fileContents = {};

  bool isLoading = false;

  _ArchivesState() {
    postsStore = PostsStore();
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.red[900],
        leading: !isLoading
            ? null
            : (Container(
                padding: EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ))),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditor(PostData({})),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 0),
        child: ListView.builder(
          itemCount: (data) == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            PostData post = PostData(data[index]);
            //post.uploadAttachments();
            return postTile(post, context);
          },
        ),
      ),
    );
  }

  Widget postTile(post, BuildContext context) {
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
                        image: getFeaturedImageWidget(post, context),
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
                      value: 'preview',
                      child: Text('Preview'),
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
                        openEditor(post);
                        break;
                      case 'preview':
                        print('Preview');
                        print(post.getHtmlContent());
                        break;
                      case "set-featured":
                        setFeaturedImage(post, context);
                        break;
                      case "delete":
                        deletePost(post);
                        break;
                      case "publish":
                        /*
                          * OPERATION TO SEND TO API AND GET IT PUBLISHED USING WP API
                          * */
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

  ImageProvider getFeaturedImageWidget(PostData post, BuildContext context) {
    ImageProvider image;
    image = AssetImage('assets/default.png');
    if (post.featuredImage != null) {
      image = FileImage(post.getFeaturedImage());
    }
    return image;
  }

  void deletePost(post) async{
    await postsStore.delete(post.id);
    getData();
  }

  setFeaturedImage(post, context) {
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

  saveSelectedImageAsFeatured(post, newImage) {
    post.setFeaturedImage(newImage);
    _savePostToFile(post);
  }

  void _savePostToFile(post) async{
    print('saving in progress');
    await postsStore.saveAsPost(post);
    getData();
  }

  Future<File> openGallery() async =>
      await ImagePicker.pickImage(source: ImageSource.gallery);

  Future<File> openCamera() async =>
      await ImagePicker.pickImage(source: ImageSource.camera);

  /*
  * OPENS THE EDITOR
  * WAITS FOR THE POP EVENT
  * SAVES THE NEW POST/UPDATED POST ONLY IF POST CONTENT HAS BEEN ADDED ORD THE POST TITLE WAS CHANGED FROM THE DEFAULT
  */
  void openEditor(PostData post) async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage(post)))
        .then((post) {
      if (!(post.title == "Untitled" && post.content.length <= 1)) {
        _savePostToFile(post);
      } else {
        print('not saved');
      }
    });
  }

  Future<String> getData() async {
    // ENABLE THE LOADING STATE
    setState(() {
      isLoading = true;
    });

    print('read');

    // READ FROM THE FILE
    await postsStore.read();
    fileContents = postsStore.getStoreContents();

    // AFTER A DELAY REBUILD THE UI
    Future.delayed(const Duration(milliseconds: 500), () {
      data = [];
      setState(() {
        fileContents.forEach((k, v) {
          //print(v);
          v['id'] = k;
          data.add(v);
        });
        isLoading = false;
      });
    });


    return 'Success';
  }
}
