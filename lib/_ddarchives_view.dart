import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/post_data.dart';
import 'widgets/posts_list.dart';
import 'package:provider/provider.dart';
import 'models/posts_data.dart';
import 'user_details.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<PostsList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  int selectedIndex = 0;
  final widgetOptions = [
    Text('Beer List'),
    Text('Add new beer'),
    Text('Favourites'),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<PostsCollection>(context, listen: false).read();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.red[900],
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'userInfo');
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'yka-home');
            },
            icon: Icon(Icons.chrome_reader_mode),
          )
        ],
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
          Icons.library_add,
        ),
        backgroundColor: Colors.red[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Selector<PostsCollection, int>(
            selector: (_, postsCollection) => postsCollection.posts.length,
            builder: (context, collection, child) => PostList(scaffoldKey),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_drink), title: Text('Posts')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode), title: Text('Homepage')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch(index){
      case 0: break;
      case 1:
        Navigator.pushNamed(context, 'yka-home'); break;
    }
    print(index);
  }

  /*
  * OPENS THE EDITOR
  * WAITS FOR THE POP EVENT
  * SAVES THE NEW POST/UPDATED POST ONLY IF POST CONTENT HAS BEEN ADDED ORD THE POST TITLE WAS CHANGED FROM THE DEFAULT
  */
  void openEditor() async {
    PostData newPost = PostData({});
    PostsCollection postsCollection =
        Provider.of<PostsCollection>(context, listen: false);

    bool toUpdate = await newPost.actionRenameTitle(context);

    if (toUpdate) {
      postsCollection.addItem(newPost);
      toUpdate = await newPost.actionEdit(context);
      if (toUpdate) {
        await postsCollection.write();
        //await Provider.of<PostsCollection>(context, listen:false).addItem(newPost);
      }
    }
  }
}
