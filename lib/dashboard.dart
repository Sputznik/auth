import 'package:auth/search_bar.dart';
import 'package:auth/yka_posts.dart';
import 'package:flutter/material.dart';
import 'package:auth/archives_view.dart';
import 'package:auth/yka-home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _children = [YkaPosts(), YkaSearchPosts(), PostsList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: bottomNavBar(),
    );
  }

  //  Bottom navigation bar
  onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Your Posts'),
        ),
      ],
      currentIndex: _currentIndex,
      fixedColor: Colors.red[900],
      onTap: onTappedBar,
    );
  }
}
