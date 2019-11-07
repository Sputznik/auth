//import 'package:flutter/cupertino.dart';
import 'package:auth/login.dart';
import 'package:auth/user_details.dart';
import 'package:flutter/material.dart';
import 'models/posts_data.dart';
import 'archives_view.dart';
import 'package:provider/provider.dart';
import "helpers/wp.dart";
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // SET THE BASE URL FOR THE WORDPRESS API
  //Wordpress.getInstance().initialize('https://churchbuzz.in/wp-json/');

  Wordpress.getInstance().initialize('http://192.168.43.225/wordpress/');

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
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuickStartAppState();
  }
}

class _QuickStartAppState extends State<QuickStartApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  _autoLogin() async {
    print('auto login');

    bool flag = await Wordpress.getInstance().hasValidAuthKey();

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
        "login": (BuildContext context) => LoginPage(),
        "posts": (BuildContext context) => PostsList(),
        "userInfo" : (BuildContext context) => UserDetails(),
        /*"/editor": (context) => EditorPage(post),*/
      },
      home: (_isLoggedIn) ? PostsList() : LoginPage(),
    );
  }
}

/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Quick Start")),
      body: Center(
        child: FlatButton(
          child: Text("Open editor"),
          onPressed: () => navigator.pushNamed("/editor"),
        ),
      ),
    );
  }
}
*/
