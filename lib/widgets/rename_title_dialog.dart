import 'package:flutter/material.dart';

class RenameTitleDialog extends StatefulWidget {
  final String title;

  RenameTitleDialog(this.title);

  @override
  _RenameTitleDialogState createState() => _RenameTitleDialogState();
}

class _RenameTitleDialogState extends State<RenameTitleDialog> {

  TextEditingController postTitleController;

  var postTitle;

  _RenameTitleDialogState() {

    //Post title field
    this.postTitle = createPostTitleWidget('');
  }

  void initState() {
    super.initState();
    setState(() {
      postTitle = createPostTitleWidget(widget.title);
    });
  }

  TextFormField createPostTitleWidget(String text) {
    postTitleController = TextEditingController(text: text);
    return TextFormField(
      keyboardType: TextInputType.multiline,
      controller: postTitleController,
      maxLines: null,
      cursorColor: Colors.black,
      autofocus: true,
      style: TextStyle(fontSize: 20, color: Colors.black),
      decoration: InputDecoration(
        //border: InputBorder.none,
        //focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 15, right: 0),
        hintText: 'New Title',
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Article Title', style: TextStyle(fontSize: 22.0)),
      content: postTitle,
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
            child: Text("Save"),
            onPressed: () =>
                Navigator.of(context).pop(postTitleController.text)),
      ],
    );
  }
}
