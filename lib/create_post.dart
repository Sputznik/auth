import 'package:flutter/material.dart';

class CreatePost extends StatelessWidget {
//  final Function getPosts;
  final Function createPost;
  CreatePost(this.createPost);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
//            print('Publish button pressed');
            createPost();
          },
          child: Text('Publish Post'),
        ),
      ),
    );
  }

}
