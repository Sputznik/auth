import 'package:auth/helpers/wp.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String _displayName = '';
  String _emailID = '';
  String _avatar = '';

  @override
  void initState() {
    super.initState();

    Wordpress wp = Wordpress.getInstance();

    this._displayName = wp.user.name;
    this._avatar = wp.user.avatar_urls['96'];
    print(wp.user.avatar_urls['96']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_displayName),
        backgroundColor: Colors.red[900],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: _avatar,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
                width: 80.0,
                  height: 80.0,
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              height: 30.0,
              child: RaisedButton(
                color: Colors.red[900],
                onPressed: () {
                  _deleteAuthKey(context);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Logout
  _deleteAuthKey(BuildContext context) async {
    Wordpress.getInstance().disposeAuthKeyFromFile();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }
}