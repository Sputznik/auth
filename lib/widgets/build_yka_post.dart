import 'package:auth/models/wp_posts_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class BuildYkaPost extends StatelessWidget {
  final List<WpPost> posts;
  final int index;
  final BuildContext context;

  BuildYkaPost(
      {@required this.posts, @required this.index, @required this.context});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: buildPostItem(index),
      onTap: () {
        Navigator.pushNamed(context, 'yka-single-post', arguments: {
          'title': posts[index].postTitle.title,
          'content': posts[index].postContent.content,
          'featured': posts[index].postFeatured
        });
      },
    );
  }

  Widget buildPostItem(index) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        children: <Widget>[
          buildPostImage(index),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - (90 + 30 + 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildPostTitle(index),
                SizedBox(
                  height: 10,
                ),
                buildPostDate(index)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPostImage(index) {
    return Container(
      width: 120.0,
      height: 90.0,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: posts[index].postFeatured,
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/default.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPostTitle(index) {
    return Text(
      posts[index].postTitle.title.toUpperCase(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildPostDate(index) {
    var published = timeago.format(posts[index].postDate);
    return Flexible(
      child: Row(
        children: <Widget>[
          Text(
            'Published $published',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          SizedBox(width: 5.0),
        ],
      ),
    );
  }
}
