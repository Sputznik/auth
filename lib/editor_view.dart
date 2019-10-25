import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'widgets/zefyr_image_picker.dart';
import 'models/post_data.dart';


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

  ImageDelegate _imgDelegate;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    setState(() {
      _controller = ZefyrController(widget.post.getContent());
      postTitle = createPostTitleWidget(widget.post.getTitle());
      _imgDelegate = ImageDelegate(widget.post);
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
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 0, bottom: 10, top: 10, right: 0),
        hintText: 'New Title',
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If _controller is null we show Material Design loader, otherwise
    // display Zefyr editor.
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
              imageDelegate: _imgDelegate,
              //selectionControls: SelectionDelegate(),
              toolbarDelegate: ToolbarDelegate(),
              //ZefyrToolbarDelegate toolbarDelegate
            ),
          );

    return WillPopScope(
      // GET CURRENT POST & PASS THE POST DATA TO THE PREVIOUS SCREEN FOR SAVING
      onWillPop: () {
        updateParentPost();
        Navigator.pop(context, widget.post);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Text(postTitleController.text),
            onTap: () {
              _showDialog();
            },
          ),
          backgroundColor: Colors.red[900],
          toolbarOpacity: 0.8,
          titleSpacing: 0,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _showDialog();
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
          ],
          //automaticallyImplyLeading: false,
        ),
        body: body,
      ),
    );
  }

  void updateParentPost() {
    widget.post.title = getCurrentTitle();
    widget.post.content = getCurrentDoc();
  }

  String getCurrentTitle() =>
      postTitleController.text != "" ? postTitleController.text : "Untitled";

  NotusDocument getCurrentDoc() => _controller.document;
}
