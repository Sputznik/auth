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
      body: ListView.builder(
        itemCount: (data) == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          PostData post = PostData(
              data[index]['key'],
              data[index]['title'],
              DateTime.parse(data[index]['created_at']),
              data[index]['content']);
          //print(post);
//          return InkWell(
//            child: Card(
//              child: Container(
//                padding: EdgeInsets.all(20.0),
//                child: Text(post.getTitle()),
//              ),
//            ),
//            onTap: () => openEditor(post),
//          );
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  post.getTitle(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(post.getCreatedAt(),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(post
                          .getContent()
                          .toPlainText()
                          .replaceAll('\n', ' ')),
                    ],
                  ),
                ),
                trailing: Container(
                    child: IconButton(
                  onPressed: () {
                    print('Tapped more');
                  },
                  icon: Icon(Icons.more_vert),
                )),
                onTap: () => openEditor(post),
              ),
              Container(
                margin: EdgeInsets.only(left: 18.0),
                child: Divider(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void openEditor(PostData post) async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage(post)))
        .then((post) {
      print("hello");

      print(post);

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
