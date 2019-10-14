import 'dart:ui';
import 'dart:io';
import 'package:auth/zefyr_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'file.dart';

class JsonConvert extends StatefulWidget {
  @override
  _JsonConvertState createState() => _JsonConvertState();
}

class _JsonConvertState extends State<JsonConvert> {
  List data = [];
  Map fileContents = {};

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
        return listTile(post, context);
      },
    );
    return listView;
  }

  Widget listTile(post, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Container(
            width: 100,
            height: 100,
            child: createFeaturedImage(post, context),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Text(
              post.getTitle(),
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Container(
//            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.getContent().toPlainText().replaceAll('\n', ' '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(post.getCreatedAt(),
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          trailing: Container(
              width: 30.0,
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                      openEditor(post);
                      break;
                    case "set-featured":
                      setFeaturedImage(post, context);
                      break;
                    case "delete":
                      post.delete(fileContents).then((_) {
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
              )),
          //onTap: () => openEditor(post),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 5.0,
          ),
          child: Divider(
            height: 1,
            thickness: 0.3,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  createFeaturedImage(post, BuildContext context) {
    Widget image;

    image = Image.asset('assets/default.png', fit: BoxFit.cover);

    if(post.featuredImage != null){
      image = Image.file(post.getFeaturedImage(), fit: BoxFit.cover);
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
                    openCamera().then((newImage){
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
                    openGallery().then((newImage){
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
    showDialog(
        context: context, builder: (BuildContext context) => featuredDialog);
  }

  saveSelectedImageAsFeatured(post, newImage){
    post.setFeaturedImage(newImage);
    post.saveToFile(fileContents).then((_){
      getData();
    });
  }

  Future<File> openGallery() async => await ImagePicker.pickImage(source: ImageSource.gallery);

  Future<File> openCamera() async => await ImagePicker.pickImage(source: ImageSource.camera);

  void openEditor(PostData post) async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage(post)))
        .then((post) {
      // SAVE ONLY IF POST CONTENT HAS BEEN ADDED OR THE POST TITLE HAS BEEN CHANGED
      if (!(post.title == "Untitled" && post.content.length <= 1)) {
        post.saveToFile(fileContents).then((_) {
          getData();
        });
      } else {
        print('not saved');
      }
    });
  }

  Future<String> getData() async {
    FileHelper helper = FileHelper();
    data = [];
    helper.readFileContents().then((value) {
      fileContents = value;
      // REBUILD THE UI WHEN DATA HAS BEEN UPDATED
      setState(() {
        value.forEach((k, v) {
          v['id'] = k;
          data.add(v);
        });
        //print(data);
      });
    });
    return 'Success';
  }
}
