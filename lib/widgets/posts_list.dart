import 'package:auth/models/post_data.dart';
import 'package:auth/widgets/post_tile.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  final List<PostData> posts;

  PostList({@required this.posts});

  @override
  Widget build(BuildContext context) {
    if(posts == null){ return SizedBox.shrink(); }
    return ListView(
      children: getChildren(),
    );
  }

  List<Widget> getChildren() {
    return posts.map((post) => PostTile(post: post)).toList();
  }
}