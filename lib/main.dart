import 'package:auth/file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './zefyr_editor.dart';
import 'archive.dart';
import 'json.dart';

void main() {
  runApp(QuickStartApp());
}

class QuickStartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostData post = PostData("", "Untitled", []);

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.red,
      ),
      title: 'Notes',
      initialRoute: '/',
      routes: {
        "/": (context) => JsonConvert(),
        "/editor": (context) => EditorPage(post),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Quick Start")),
      body: Center(
        child: FlatButton(
          child: Text("Open editor"),
          onPressed: () => navigator.pushNamed("/editor"),
        ),
      ),
    );
  }
}























//class Homepage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _Homepage();
//  }
//}

//class _Homepage extends State<Homepage> {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(primarySwatch: Colors.lightBlue),
//      home: MyAppPage(),
//    );
//  }

// Base URL for our wordpress API
//  final String apiUrl = "https://churchbuzz.in/wp-json/wp/v2/users/me";

  // Empty list for our posts
//  List posts;

  // Function to fetch list of posts
//  Future<String> getPosts() async {
//    String adminName = 'samvthom16@gmail.com';
//    String adminKey = 'MqBM wtxS heJy 6swD 3c3k C5RL';
//    String str = adminName + ':' + adminKey;
//    String base64 = base64Encode(utf8.encode(str));
//    print(base64);
//    var $headers = {
//      "Accept": "application/json",
//      "Authorization": 'Basic $base64'
//    };
//    http.Response res =
//    await http.get(Uri.encodeFull(apiUrl), headers: $headers);
//    print(res.body);
//  }

  // Function to create post
//  Future<String> createPost() async {
//    String adminName = 'samvthom16@gmail.com';
//    String adminKey = 'MqBM wtxS heJy 6swD 3c3k C5RL';
//    String str = adminName + ':' + adminKey;
//    String base64 = base64Encode(utf8.encode(str));

//    final Map<String, dynamic> postData = {
////      'Authorization': base64,
//      'title': 'Sample',
//      'content': 'Sample Content',
//      'status': 'draft'
//    };
//    final createPostUrl = 'https://churchbuzz.in/wp-json/wp/v2/posts?title='+title+'&content='+content+'&status='+status;
//    final createPostUrl = 'https://churchbuzz.in/wp-json/wp/v2/posts';
//    var $headers = {
//      "Accept": "application/json",
//      "Authorization": 'Basic $base64'
//    };
//    var response =
//        await http.post(createPostUrl, body: postData, headers: $headers);
//    return response.body;
//
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');

//    var data = { 'title' : 'My first post' };
//    http.Request(
//        'https://jsonplaceholder.typicode.com/posts',
//        method: 'POST',
//        sendData: json.encode(data),
//        requestHeaders: {
//          'Content-Type': 'application/json; charset=UTF-8'
//        }
//    ).then((resp) {
//      print(resp.responseUrl);
//      print(resp.responseText);
//    });

//    print(res.body);
//  print(createPostUrl);
//  }
//}
