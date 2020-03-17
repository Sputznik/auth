import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class YkaHomepage extends StatefulWidget {
  @override
  _YkaHomepageState createState() => _YkaHomepageState();
}

class _YkaHomepageState extends State<YkaHomepage> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yka Homepage'),
        backgroundColor: Colors.red[900],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://www.youthkiawaaz.com",
        onWebViewCreated: ( WebViewController webViewController ) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
