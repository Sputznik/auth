import 'package:flutter/material.dart';
import 'dart:convert'; // access to jsonEncode()
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:math';


import 'file.dart';

class EditorPage extends StatefulWidget {
  String id;

  EditorPage(id){
    this.id = id;
  }

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });



  }

  String getRandomID(){
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
      onWillPop: (){
        Navigator.pop(context, true);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editor page"),
          backgroundColor: Colors.red[900],
//          automaticallyImplyLeading: false,
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.save),
                onPressed: () => _saveDocument(context),
              ),

            )
          ],
        ),
        body: body,
      ),
    );
  }
  /// Loads the document to be edited in Zefyr.
  Future<NotusDocument> _loadDocument() async{
    fileHelper helper = fileHelper();
    final contents = await helper.readFileContents();

    if(contents.length > 0 && widget.id != ""){
      var json_str = jsonEncode(contents[widget.id]);
      return NotusDocument.fromJson(jsonDecode(json_str));
    }

    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }



  void _saveDocument(BuildContext context) {
    String id = widget.id !="" ? widget.id : getRandomID();

    fileHelper helper = fileHelper();

    final currentContent = _controller.document.toJson(); //jsonEncode(_controller.document);

    helper.readFileContents().then(( fileContents ){
      fileContents[ id ] = currentContent;
      helper.writeFileContents(jsonEncode(fileContents)).then((_){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
      });
    });


  }





}
