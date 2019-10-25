import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/post_data.dart';
import 'widgets/posts_list.dart';
import 'package:provider/provider.dart';
import 'models/posts_data.dart';


class PostsList extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<PostsList> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<PostsCollection>(context, listen:false).read();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Selector<PostsCollection, int>(
          selector: (_, postsCollection) => postsCollection.posts.length,
          builder: (context, collection, child) => PostList(),
        )
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
    bool toUpdate = await newPost.actionEdit(context);
    if(toUpdate){
      await Provider.of<PostsCollection>(context, listen:false).addItem(newPost);
    }
  }
}
