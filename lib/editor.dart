import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class Editor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditorState();
  }
}

class _EditorState extends State<Editor> {
  final _titleControl = TextEditingController();
  final _contentControl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleControl.dispose();
    _contentControl.dispose();
    super.dispose();
  }

    final postTitle = TextField(
    cursorColor: Colors.white,
    autofocus: false,
    style: TextStyle(fontSize: 20, color: Colors.white),
    decoration: InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      hintText: 'Title',
      hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
    ),
  );

  final postContent = TextFormField(
    maxLines: 8,
    decoration: InputDecoration(
      hintText: 'Description',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//      border: OutlineInputBorder(
//        borderRadius: BorderRadius.circular(32.0),
//      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: postTitle,


      ),
      body: ListView(
        children: <Widget>[
          postContent,
          RaisedButton(
            onPressed: (){},
            child: Icon(
              Icons.add
            ),
          ),
        ],
      ),
    );
  }
}
