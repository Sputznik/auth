
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/post_data.dart';
import './editor_view.dart';


import 'models/posts_data.dart';

import 'archives_view.dart';

import 'package:provider/provider.dart';

import "helpers/wp.dart";


void main() {

  // SET THE BASE URL FOR THE WORDPRESS API
  Wordpress.getInstance().initialize('https://churchbuzz.in/wp-json/');

  //Wordpress.getInstance().initialize('http://192.168.43.253/wordpress/wp-json/');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => PostsCollection()),
      ],
      child: QuickStartApp(),
    ),
  );

  //runApp(QuickStartApp());
}

class QuickStartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    PostData post = PostData({});

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          buttonTheme: ButtonThemeData(minWidth: 5,),
          textTheme: TextTheme(button: TextStyle(fontSize: 12)),
          primarySwatch: Colors.red,
          brightness: Brightness.light
      ),
      title: 'Notes',
      initialRoute: '/',
      routes: {
        "/": (context) => PostsList(),
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
