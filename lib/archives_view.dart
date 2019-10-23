import 'dart:ui';
import 'package:auth/editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/post_data.dart';
import 'widgets/posts_list.dart';
import 'package:provider/provider.dart';
import 'models/posts_data.dart';

import 'helpers/wp.dart';


class PostsList extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<PostsList> {

  List<PostData> posts;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    //Wordpress.getInstance().test();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.red[900],
        leading: !isLoading
            ? null
            : (Container(
                padding: EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ))),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditor(),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 0),
        child: PostList(posts: posts)
      ),
    );
  }

  /*
  * OPENS THE EDITOR
  * WAITS FOR THE POP EVENT
  * SAVES THE NEW POST/UPDATED POST ONLY IF POST CONTENT HAS BEEN ADDED ORD THE POST TITLE WAS CHANGED FROM THE DEFAULT
  */
  void openEditor() async {
    PostData newPost = PostData({});

    // OLD SNAPSHOT
    String oldPostData = newPost.toString();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditorPage(newPost)))
        .then((newPost) {
      if (newPost.toString() != oldPostData) {
        Provider.of<PostsCollection>(context, listen:false).addItem(newPost);
      }
    });
  }

  void getData() async {

    // ENABLE THE LOADING STATE
    setState(() {
      isLoading = true;
    });



    await Provider.of<PostsCollection>(context, listen:false).read();

    // DISABLE THE LOADING STATE
    setState(() {
      posts = Provider.of<PostsCollection>(context, listen:false).posts;
      isLoading = false;
    });
  }
}
