import 'package:auth/widgets/build_yka_post.dart';
import 'package:flutter/material.dart';
import 'package:auth/helpers/wp.dart';
import 'package:auth/services/wp_posts_service.dart';
import 'package:auth/models/wp_posts_model.dart';

class YkaSearchPosts extends StatefulWidget {
  @override
  _YkaSearchPostsState createState() => _YkaSearchPostsState();
}

class _YkaSearchPostsState extends State<YkaSearchPosts> {
  Wordpress _wordpress = Wordpress.getInstance();

  List<WpPost> _posts = [];

  TextEditingController _controller = TextEditingController();

  String searchQuery = '';

  String emptyResult = 'Search Articles';

  bool loaderFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchInput(),
        backgroundColor: Colors.red[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => _controller.clear(),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: searchQuery.isEmpty
          ? isSearchEmpty()
          : (loaderFlag ? searchNotEmpty() : isSearchEmpty()),
    );
  }

  //Visible when search input is empty
  Widget isSearchEmpty() {
    return Container(
      alignment: Alignment.center,
      child: Text(emptyResult),
    );
  }

  //Visible when search input is not empty
  Widget searchNotEmpty() {
    return (searchQuery != '' && _posts.length == 0)
        ? Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Searching for $searchQuery'),
                SizedBox(
                  height: 10.0,
                ),
                CircularProgressIndicator()
              ],
            ),
          )
        : ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              return BuildYkaPost(
                context: context,
                index: index,
                posts: _posts,
              );
            });
  }

  Widget searchInput() {
    return TextField(
      cursorColor: Colors.white,
      enableSuggestions: true,
      style: TextStyle(
        color: Colors.white,
      ),
      controller: _controller,
      decoration: InputDecoration(
          hintText: 'Search Articles',
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onSubmitted: (val) {
        setState(() {
          searchQuery = val;
          loaderFlag = true;
        });
        userSearch();
      },
    );
  }

  //Returns posts based on user search input
  userSearch() async {
    //Empty the existing posts list
    _posts.clear();

    var list = await _wordpress.getPosts(
        endPoint: 'wp-json/wp/v2/posts?search=$searchQuery&status=publish');

    //Check for search result empty/not empty
    if (list.length > 0) {
      var finalList = await loadPosts(list);

      /*Loops through all the fetched posts and
    **Stores all the posts in posts[] list.
    */
      for (var i = 0; i < finalList.length; i++) {
        _posts.add(finalList[i]);
      }

      setState(() {});
    } else {
      setState(() {
        loaderFlag = false;
        emptyResult = 'Sorry, we couldn\'t find any results for "$searchQuery"';
      });
    }
  }
}
