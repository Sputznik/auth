import 'package:auth/widgets/rename_title_dialog.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'widgets/zefyr_image_picker.dart';
import 'widgets/post_options.dart';
import 'models/post_data.dart';

class EditorPage extends StatefulWidget {
  final PostData post;

  EditorPage(this.post);

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  EditorPageState();

  // Allows to control the editor and the document.
  ZefyrController _controller;

  // Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  // IMAGE WIDGET WITHIN ZEFYR EDITOR
  ImageDelegate _imgDelegate;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    setState(() {
      _controller = ZefyrController(widget.post.getContent());
      _imgDelegate = ImageDelegate(widget.post);
    });
  }

  // If the _controller is null then we show the loader, otherwise display Zefyr editor.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // GET CURRENT POST & PASS THE POST DATA TO THE PREVIOUS SCREEN FOR SAVING
      onWillPop: () {
        updateParentPost();
        Navigator.pop(context, widget.post);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            title: GestureDetector(child: Text(widget.post.title)),
            toolbarOpacity: 0.8,
            titleSpacing: 0,
            actions: <Widget>[PostOptionsMenu(post: widget.post, hideActions: ['edit', 'delete'],)]),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
              imageDelegate: _imgDelegate,
              toolbarDelegate: ToolbarDelegate(),
            ),
          );
  }

  void updateParentPost() => widget.post.content = _controller.document;
}
