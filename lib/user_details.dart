import 'package:auth/helpers/wp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserName'),
        backgroundColor: Colors.red[900],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Logout'),
            onTap: (){
              print('Logout');
              deleteAuthKey(context);
            },
          )
        ],
      ),
    );
  }

  deleteAuthKey(BuildContext context) async{
    Wordpress.getInstance().disposeAuthKeyFromFile();
    Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }

}
