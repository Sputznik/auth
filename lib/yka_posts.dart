import 'package:auth/helpers/wp.dart';
import 'package:auth/services/wp_posts_service.dart';
import 'package:flutter/material.dart';
import 'package:auth/models/wp_posts_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/cupertino.dart';

class YkaPosts extends StatefulWidget {
  @override
  _YkaPostsState createState() => _YkaPostsState();
}

class _YkaPostsState extends State<YkaPosts> {
  Wordpress _wordpress = Wordpress.getInstance();

  int page = 1;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;

  List<WpPost> posts = [];

  loadPostsData() async {
    //Shows loader while fetching data from the server
    isLoading = true;

    var list = await _wordpress.getPosts(
        endPoint: 'wp-json/wp/v2/posts?page=$page&per_page=5&status=publish');
    var finalList = await loadPosts(list);

    /*Loops through all the fetched posts and
    **Stores all the posts in posts[] list.
    */
    for (var i = 0; i < finalList.length; i++) {
      posts.add(finalList[i]);
    }
    /**
     * Hides loader after the data
     * has been fetched from the server
     */
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadPostsData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          centerTitle: true,
          backgroundColor: Colors.red[900],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('Search');
                //showSearch(context: context, delegate: DataSearch());
                Navigator.pushNamed(context, 'yka-search');
              },
            )
          ],
        ),
        body: isLoading ? postLoader() : buildPostContainer());
  }

  Widget buildPostContainer() {
    return Container(
      padding: EdgeInsets.only(bottom: 12.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: posts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            //Shows bottom loader
            if (index == posts.length) {
              return Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: CupertinoActivityIndicator());
            }
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
          }),
    );
  }

  Widget postLoader() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text('Loading Posts'),
        ],
      ),
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
            width: MediaQuery
                .of(context)
                .size
                .width - (90 + 30 + 30),
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
        placeholder: (context, url) =>
            Container(
              alignment: Alignment.center,
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(),
            ),
        errorWidget: (context, url, error) =>
            Image.asset(
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
    return Row(
      children: <Widget>[
        Text(
          'Published $published',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        SizedBox(width: 5.0),
      ],
    );
  }

  //Detects the page bottom
  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      /**
       * Increment page number
       * for fetching more posts
       */
      page++;
      loadPostsData();
      print('Reached Bottom');
    }
  }
}
