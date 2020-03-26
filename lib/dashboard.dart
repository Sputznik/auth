import 'package:auth/yka_posts.dart';
import 'package:flutter/material.dart';
import 'package:auth/archives_view.dart';
import 'package:auth/yka-home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _children = [PostsList(), YkaHomepage(), YkaPosts()];

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
            icon: Icon(Icons.library_books), title: Text('All Posts')),
        BottomNavigationBarItem(
            icon: Icon(Icons.chrome_reader_mode), title: Text('Homepage')),
        BottomNavigationBarItem(
            icon: Icon(Icons.all_out), title: Text('Posts')),
      ],
      currentIndex: _currentIndex,
      fixedColor: Colors.red[900],
      onTap: onTappedBar,
    );
  }
}
