import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

  final _emailField = TextFormField(
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

  final _loginButton = RaisedButton(
    onPressed: () {
      print('Email: $_emailController.text');
      print('Password: $_passwordController.text');
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
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
            _loginButton
          ],
        ),
      ),
    ));
  }
}
