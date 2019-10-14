import 'dart:ui' as prefix0;
import 'dart:ui';

import 'package:auth/zefyr_editor.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
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
        onPressed: () =>
            openEditor(PostData("", "Untitled", new DateTime.now(), [])),
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

  Widget createListView(data){
    Widget listView =  ListView.builder(
      itemCount: (data) == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        PostData post = PostData(
            data[index]['key'],
            data[index]['title'],
            DateTime.parse(data[index]['created_at']),
            data[index]['content']);
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
            child: Image.asset('assets/default.png',
                fit: BoxFit.cover
            ),
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
                    case "set-featured":
                      print("set-featured");
                      break;
                    case "delete":
                      post.delete(fileContents).then((_){
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
          onTap: () => openEditor(post),
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
          v['key'] = k;
          data.add(v);
        });
        //print(data);
      });
    });
    return 'Success';
  }
}
