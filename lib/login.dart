import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _output = '';
  final _formKey = GlobalKey<FormState>();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showPassword();
  }

  final _emailField = TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'Username cannot be empty';
      }
      return null;
    },
    keyboardType: TextInputType.emailAddress,
    controller: _emailController,
    cursorColor: Colors.red,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      labelText: 'Email',
      prefixIcon: Icon(Icons.person),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );

  final _passwordField = TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return 'Password cannot be empty';
      }
      return null;
    },
    keyboardType: TextInputType.text,
    controller: _passwordController,
    cursorColor: Colors.red,
    obscureText: true,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      labelText: 'Password',
      prefixIcon: Icon(Icons.remove_red_eye),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              children: <Widget>[
                Text(
                  'Login'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900]),
                ),
                SizedBox(
                  height: 20.0,
                ),
                _emailField,
                SizedBox(
                  height: 10.0,
                ),
                _passwordField,
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _webLogin(_emailController.text, _passwordController.text)
                          .then((appPass) {
                            print(appPass);
                        _savePassword(appPass);
                      });
//                      _webLogin(_emailController.text, _passwordController.text);
                    }
                  },
                  padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Login'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: (_output) != null
                      ? Text(_output)
                      : Text('No password found!!!!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _webLogin(String _username, String _password) async {
    //Encode the username and password
    _username = base64.encode(utf8.encode(_username));
    _password = base64.encode(utf8.encode(_password));

    //Redirect to the server for getting a random application password
    String _loginUrl =
        'https://churchbuzz.in/wp-admin/admin-ajax.php?action=auth_with_flutter';

    final Map<String, dynamic> userInfo = {
      'ukey': _username,
      'pkey': _password
    };

    var $headers = {"Accept": "application/json"};
    var response =
        await http.post(_loginUrl, body: userInfo, headers: $headers);

    return response.body;
  }

  //Stores the application password in shared preference
  _savePassword(String data) async {
    final preference = await SharedPreferences.getInstance();
    preference.setString('user_pass', data);
  }

  //Retrive the application password
  _showPassword() async {
    final preference = await SharedPreferences.getInstance();
    _output = preference.getString('user_pass');
  }
}
