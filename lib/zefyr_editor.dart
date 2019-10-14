import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'dart:math';

import 'file.dart';

class EditorPage extends StatefulWidget {

  final PostData post;

  EditorPage(this.post);

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  TextEditingController postTitleController;
  var postTitle;

  EditorPageState() {
    //Post title field
    this.postTitle = createPostTitleWidget("Untitled");
  }

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    setState(() {
      _controller = ZefyrController(widget.post.getContent());
      postTitle = createPostTitleWidget(widget.post.getTitle());
    });
  }

  TextFormField createPostTitleWidget(String text){
    postTitleController = TextEditingController(text: text);
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: postTitleController,
      maxLines: null,
      cursorColor: Colors.black,
      autofocus: true,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: 'Title',
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }

  Widget inputDetector() {
    return GestureDetector(
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          labelText: postTitleController.text != "" ? postTitleController.text : "Untitled",
          labelStyle: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
      ),
      onTap: () {
        _showDialog();
      },
    );
  }


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Rename Title'),
          content: postTitle,
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Save"),
              onPressed: () {
                print(postTitleController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  @override
  Widget build(BuildContext context) {
    // If _controller is null we show Material Design loader, otherwise
    // display Zefyr editor.
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
//        toolbarDelegate: ,
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
            ),
          );

    return WillPopScope(
      onWillPop: () {
        // GET CURRENT POST
        PostData post = getCurrentPost();

        // PASS THE POST DATA TO THE PREVIOUS SCREEN FOR SAVING
        Navigator.pop(context, post);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
//          title: postTitle,
          title: inputDetector(),
          backgroundColor: Colors.red[900],
//          automaticallyImplyLeading: false,
        ),
        body: body,
      ),
    );
  }

  PostData getCurrentPost(){
    widget.post.title = getCurrentTitle();
    widget.post.content = getCurrentDoc();
    /*
    PostData post = PostData({ 'id': widget.post.id, 'title': getCurrentTitle(), 'created_at': widget.post.created_at });
    // THIS NEEDS TO BE EXPLICITLY SET OTHERWISE WILL THROW A TYPE ERROR
    post.content = getCurrentDoc();
    */
    return widget.post;
  }

  String getCurrentTitle() => postTitleController.text != "" ? postTitleController.text : "Untitled";

  NotusDocument getCurrentDoc() => _controller.document;

}
