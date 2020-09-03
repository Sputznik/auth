import 'package:auth/choose_categories.dart';
import 'package:auth/dashboard.dart';
import 'package:auth/login.dart';
import 'package:auth/search_bar.dart';
import 'package:auth/user_details.dart';
import 'package:auth/yka-home.dart';
import 'package:auth/yka_posts.dart';
import 'package:auth/yka_single_post.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/posts_data.dart';
import 'archives_view.dart';
import 'package:provider/provider.dart';
import "helpers/wp.dart";
import 'package:flutter/services.dart';

void main() {
  // SET THE BASE URL FOR THE WORDPRESS API
  //Wordpress.getInstance().initialize('https://churchbuzz.in/wp-json/');
  Wordpress.getInstance().initialize('https://www.ykasandbox.com/');
//  Wordpress.getInstance().initialize('http://192.168.43.225/yka/');

  //Forces device orientation to be Portrait only.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PostsCollection()),
        ],
        child: QuickStartApp(),
      ),
    );
  });

  //runApp(QuickStartApp());
}

class QuickStartApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickStartAppState();
}

class _QuickStartAppState extends State<QuickStartApp> {
  bool _isLoggedIn;
  bool _initialScreen = false;

  @override
  void initState() {
    super.initState();
    checkTopicsSeen();
  }

  // CHECKS WHETHER THE TOPICS ARE SELECTED OR NOT
  checkTopicsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool _seen = (prefs.getBool('topics') ?? false); //Setter in Categories List
    print('Seen' + _seen.toString());

    setState(() =>
        _initialScreen = _seen); //SETS THE INITIAL SCREEN AFTER AUTO-LOGIN
    _autoLogin(); // INVOKE AUTO-LOGIN
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
        "login": (BuildContext context) => LoginPage(
              autologin: false,
            ),
        "dashboard": (BuildContext context) => Dashboard(),
        "posts": (BuildContext context) => PostsList(),
        "userInfo": (BuildContext context) => UserDetails(),
        "yka-home": (BuildContext context) => YkaHomepage(),
        "yka-posts": (BuildContext context) => YkaPosts(),
        "yka-single-post": (BuildContext context) => YkaSinglePost(),
        'yka-search': (BuildContext context) => YkaSearchPosts(),
        'topics': (BuildContext context) => CategoriesList()
      },
      home: buildHome(),
//        home: homepage,
    );
  }

//  buildHome() => PostsList();

  buildHome() {
    Widget screen = !_initialScreen ? CategoriesList() : Dashboard();

    if (_isLoggedIn != null)
      return (_isLoggedIn) ? screen : LoginPage(autologin: false);
    return LoginPage(autologin: true);
  }
}
