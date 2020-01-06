import 'package:auth/models/post_data.dart';
import 'package:auth/models/posts_data.dart';
import 'package:auth/widgets/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatelessWidget {

  final scaffoldKey;

  PostList(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildren(context),
    );
  }

  List<Widget> getChildren(context) {
    var posts = Provider.of<PostsCollection>(context, listen:false).posts;
    return posts.map(
            (post) => ChangeNotifierProvider<PostData>.value(
              value: post,
              child: PostTile(this.scaffoldKey)
            )
    ).toList();
  }
}
