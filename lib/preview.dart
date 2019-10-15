import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import "file.dart";

class Preview extends StatefulWidget {

  final PostData post;

  Preview(this.post);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        child: HtmlView(
          data: widget.post.getHtmlContent()
        ),
      ),
    );
  }
}
