import 'dart:ui';
import 'dart:io';
import 'package:auth/editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'storage.dart';
import "postdata.dart";

class Archives extends StatefulWidget {
  @override
  _ArchivesState createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  List data = [];
  InternalStorage storage;
  Map fileContents = {};

  _ArchivesState() {
    this.storage = InternalStorage('test3.json');
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditor(PostData({})),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
//        padding: EdgeInsets.only(top: 5.0),
        child: createListView(data),
      ),
    );
  }

  Widget createListView(data) {
    Widget listView = ListView.builder(
      itemCount: (data) == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        PostData post = PostData(data[index]);

        //InternalStorage helper = InternalStorage(post.getFeaturedImage().path);
        // print(helper.toByteData());

        return listTile(post, context);
      },
    );
    return listView;
  }

  Widget listTile(post, BuildContext context) {
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
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      post.getContent().toPlainText().replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
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
                        post.delete(storage).then((_) {
                          getData();
                        });
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

  setFeaturedImage(post, context) {
    var featuredDialog = AlertDialog(
      title: Text('Choose Image'),
      content: Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    openCamera().then((newImage) {
                      saveSelectedImageAsFeatured(post, newImage);
                    });
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 50.0,
                    color: Colors.red[900],
                  ),
                ),
                SizedBox(
                  width: 40.0,
                ),
                IconButton(
                  onPressed: () {
                    openGallery().then((newImage) {
                      saveSelectedImageAsFeatured(post, newImage);
                    });
                  },
                  icon: Icon(
                    Icons.perm_media,
                    size: 50.0,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => featuredDialog);
  }

  saveSelectedImageAsFeatured(post, newImage) {
    post.setFeaturedImage(newImage);
    _savePostToFile(post);
  }

  void _savePostToFile(post) {
    post.saveToFile(storage).then((_) {
      //REFRESH UI
      getData();
    });
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
    data = [];
    storage.readFileContents().then((value) {
      fileContents = value;

      // REBUILD THE UI WHEN DATA HAS BEEN UPDATED
      setState(() {
        value.forEach((k, v) {
          v['id'] = k;
          data.add(v);
        });
      });
    });
    return 'Success';
  }
}
