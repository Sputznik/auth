import 'dart:ui';
import 'dart:io';
import 'package:auth/editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'io/stores.dart';
import "postdata.dart";

import "posttile_view.dart";

class PostsList extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<PostsList> {

  List data = [];

  final PostsStore postsStore = PostsStore();

  Map fileContents = {};

  bool isLoading = false;

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
        onPressed: (){
          setState(() {
            data.add({});
          });
        },
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
            return PostTile(post, postsStore);
          },
        ),
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
