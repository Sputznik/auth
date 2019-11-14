import 'package:auth/login.dart';
import 'package:auth/user_details.dart';
import 'package:flutter/material.dart';
import 'models/posts_data.dart';
import 'archives_view.dart';
import 'package:provider/provider.dart';
import "helpers/wp.dart";

void main() {

  // SET THE BASE URL FOR THE WORDPRESS API
  Wordpress.getInstance().initialize('https://churchbuzz.in/wp-json/');

  //Wordpress.getInstance().initialize('http://192.168.43.225/wordpress/');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => PostsCollection()),
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
        "posts": (BuildContext context) => PostsList(),
        "userInfo": (BuildContext context) => UserDetails(),
        /*"/editor": (context) => EditorPage(post),*/
      },
      home: buildHome(),
//        home: homepage,
    );
  }

  buildHome(){
    if(_isLoggedIn != null) return (_isLoggedIn) ? PostsList() : LoginPage(autologin: false,);
    return LoginPage(autologin: true);
  }
}
