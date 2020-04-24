import 'package:auth/helpers/wp.dart';
import 'package:auth/services/wp_posts_service.dart';
import 'package:auth/widgets/build_yka_post.dart';
import 'package:flutter/material.dart';
import 'package:auth/models/wp_posts_model.dart';
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

  bool hasPosts = true;

  List<WpPost> posts = [];

  loadPostsData() async {
    //Shows loader while fetching data from the server
    isLoading = true;

    var list = await _wordpress.getPosts(
        endPoint:
            'wp-json/wp/v2/posts?page=$page&category=25915&per_page=10&status=publish');

    //print('Array Length: ' + list.runtimeType.toString());

    if (!(list.runtimeType == Null)) {
      var finalList = await loadPosts(list);

      /*Loops through all the fetched posts and
    **Stores all the posts in posts[] list.
    */
      for (var i = 0; i < finalList.length; i++) {
        posts.add(finalList[i]);
      }
    }

    if (list.runtimeType == Null) {
      hasPosts = false;
    }

    /**
     * Hides loader after the data
     * has been fetched from the server
     */
    setState(() {
      isLoading = false;
    });
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
                child: loadMore(),
              );
            }
            return BuildYkaPost(context: context, index: index, posts: posts);
          }),
    );
  }

  Widget loadMore() => hasPosts ? CupertinoActivityIndicator() : noPosts();

  //Show message when no more posts are available
  Widget noPosts() {
    return Container(
      child: Text(
        'There are no more posts to show right now.',
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
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
      //print('Reached Bottom');
    }
  }
}
