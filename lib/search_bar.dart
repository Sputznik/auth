import 'dart:async';
import 'package:auth/helpers/wp.dart';
import 'package:auth/widgets/internet_not_available.dart';
import 'package:flutter/material.dart';
import 'package:auth/models/wp_posts_model.dart';
import 'package:auth/widgets/build_yka_post.dart';
import 'package:auth/services/wp_posts_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class YkaSearchPosts extends StatefulWidget {
  @override
  _YkaSearchPostsState createState() => _YkaSearchPostsState();
}

class _YkaSearchPostsState extends State<YkaSearchPosts> {
  Wordpress _wordpress = Wordpress.getInstance();

  StreamSubscription<DataConnectionStatus> listener;

  List<WpPost> _posts = [];

  TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String searchQuery = '';

  String emptyResult = 'Search Articles';

  bool loaderFlag = true;

  @override
  void initState() {
    super.initState();
    checkInternet(); // Check for internet connection
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchInput(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, 'dashboard'),
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
    return Visibility(
      visible: Provider.of<DataConnectionStatus>(context) ==
          DataConnectionStatus.connected,
      child: Container(
        alignment: Alignment.center,
        child: Text(emptyResult),
      ),
      replacement: InternetNotAvailable(),
    );
  }

  //Visible when search input is not empty
  Widget searchNotEmpty() {
    return (searchQuery != '' && _posts.length == 0)
        ? Visibility(
            visible: Provider.of<DataConnectionStatus>(context) ==
                DataConnectionStatus.connected,
            child: Container(
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
            ),
            replacement: InternetNotAvailable(),
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

  void showInSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Check your internet connection and try again!'),
      ),
    );
  }

  Widget searchInput() {
    return TextField(
      onTap: _posts.length != 0 &&
              Provider.of<DataConnectionStatus>(context) ==
                  DataConnectionStatus.disconnected
          ? showInSnackBar
          : null,
      readOnly: Provider.of<DataConnectionStatus>(context) ==
          DataConnectionStatus.disconnected,
      enableSuggestions: true,
      enableInteractiveSelection: false,
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
          hintText: 'Search Articles', border: InputBorder.none),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onSubmitted: (val) {
        if (val.isEmpty) {
          _focusNode
              .requestFocus(); // Prevents keyboard dismiss if search query is empty
          return;
        }
        setState(() {
          searchQuery = val;
          loaderFlag = true;
        });
        userSearch();
      },
    );
  }

  // SIMPLE CHECK TO SEE INTERNET CONNECTION
  checkInternet() async {
    // ACTIVELY LISTEN FOR STATUS UPDATES
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          if (searchQuery.isNotEmpty && _posts.isEmpty) {
            userSearch();
          }
          // print('Data connection is available.');
          break;
      }
    });
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
