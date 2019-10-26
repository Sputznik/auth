import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/post_data.dart';
import 'post_options.dart';
import 'image_cover.dart';
import 'package:provider/provider.dart';
import 'package:auth/models/posts_data.dart';

class PostTile extends StatefulWidget {
  PostTile();

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  _PostTileState();

  Widget build(BuildContext context) {
    return Consumer<PostData>(
      builder: (_, post, child) => buildItem(post),
    );

    //return buildItem(widget.post);
  }

  Widget buildItem(post) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        children: <Widget>[
          buildPostImage(post),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - (90 + 30 + 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildPostTitle(post),
                SizedBox(
                  height: 10,
                ),
                //buildPostExcerpt(context),
                //SizedBox( height: 10,),
                buildPostDate(post)
              ],
            ),
          ),
          post.isLoading ? buildLoader(post) : buildPostOptions(post)
        ],
      ),
    );
  }

  Widget buildLoader(post) {
    return Container(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
        ));
  }

  Widget buildPostOptions(post) {
    return Container(
      padding: EdgeInsets.all(0),
      width: 30,
      child: PostOptionsMenu(post: post),
    );
  }

  Widget buildPostImage(post) {
    return ImageCoverWidget(
      media: post.featuredImage,
      width: 90,
      height: 90,
    );
  }

  Widget buildPostTitle(post) {
    return Text(
      post.getTitle().toUpperCase(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /*
  Widget buildPostExcerpt(post) {
    return Text(
      widget.post.getContent().toPlainText().replaceAll('\n', ' '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  */

  Widget buildPostDate(post) {
    return Row(
      children: <Widget>[
        Text(
          post.getCreatedAt(),
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        SizedBox(
          width: 5.0,
        ),
        buildPostStatus(post)
      ],
    );
  }

  Widget buildPostStatus(post) {
    if (post.id > 0) {
      return Icon(
        Icons.check_circle,
        size: 15.0,
        color: Colors.green,
      );
    }
    return Icon(
      Icons.autorenew,
      size: 15.0,
    );
  }

/*
   * OPERATION TO SEND TO API AND GET IT PUBLISHED USING WP API
   *
  void actionPublish(postsCollection) async {
    setState(() {
      isLoading = true;
    });

    try {
      await postsCollection.publish(widget.post);
    } catch (e) {
      // Find the Scaffold in the widget tree and use it to show a SnackBar.
      final snackBar = SnackBar(
          content:
              Text('Unexpected error has occurred. Please try again later!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    setState(() {
      isLoading = false;
    });
  }

   */

}
