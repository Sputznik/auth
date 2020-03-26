import 'package:auth/dashboard.dart';
import 'package:auth/login.dart';
import 'package:auth/user_details.dart';
import 'package:auth/yka-home.dart';
import 'package:auth/yka_posts.dart';
import 'package:auth/yka_single_post.dart';
import 'package:flutter/material.dart';
import 'models/posts_data.dart';
import 'archives_view.dart';
import 'package:provider/provider.dart';
import "helpers/wp.dart";

void main() {

  // SET THE BASE URL FOR THE WORDPRESS API
  //Wordpress.getInstance().initialize('https://churchbuzz.in/wp-json/');
  Wordpress.getInstance().initialize('https://www.ykasandbox.com/');
  //Wordpress.getInstance().initialize('http://192.168.43.225/wordpress/');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostsCollection()),
      ],
      child: QuickStartApp(),
    ),
  );

  //runApp(QuickStartApp());
}

class QuickStartApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _QuickStartAppState();

}

class _QuickStartAppState extends State<QuickStartApp> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  _autoLogin() async {

    bool flag = await Wordpress.getInstance().hasValidAuthKey();

    //print('Flag below');
    //print(flag);

    // JUST TO SHOW THE LOADER FOR AUTO LOGIN
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoggedIn = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          minWidth: 5,
        ),
        textTheme: TextTheme(button: TextStyle(fontSize: 12)),
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      title: 'Notes',
//      initialRoute: _appRoute,
      routes: {
        "login": (BuildContext context) => LoginPage(autologin: false,),
        "dashboard" : (BuildContext context) => Dashboard(),
        "posts": (BuildContext context) => PostsList(),
        "userInfo": (BuildContext context) => UserDetails(),
        "yka-home": (BuildContext context) => YkaHomepage(),
        "yka-posts": (BuildContext context) => YkaPosts(),
        "yka-single-post": (BuildContext context) => YkaSinglePost()

      },
      home: buildHome(),
//        home: homepage,
    );
  }

//  buildHome() => PostsList();

  buildHome(){
    if(_isLoggedIn != null) return (_isLoggedIn) ? Dashboard() : LoginPage(autologin: false,);
    return LoginPage(autologin: true);
  }
}
