import 'package:auth/zefyr_editor.dart';
import 'package:flutter/material.dart';
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
        onPressed: () => openEditor(PostData("", "Untitled", [])),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        itemCount: (data) == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          PostData post = PostData(
              data[index]['key'], data[index]['title'], data[index]['content']);
          //print(post);
          return InkWell(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(post.getTitle()),
              ),
            ),
            onTap: () => openEditor(post),
          );
        },
      ),
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
