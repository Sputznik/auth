import 'dart:convert';

import 'helpers/wp.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _output = '';
  final _formKey = GlobalKey<FormState>();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

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
      labelText: 'Email/Username',
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
                      Wordpress.getInstance().webLogin(_emailController.text, _passwordController.text)
                          .then((appPass) {

                            if(appPass.containsKey('new_password') && appPass.containsKey('user')){
                              Wordpress.getInstance().saveAuthKeyToFile(_emailController.text, appPass['new_password'], appPass['user']);
                              _emailController.clear();
                              _passwordController.clear();
                              Navigator.pushReplacementNamed(context, 'posts');
                            }

                            else{
                              showLoginError(appPass);
                            }


                      });
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
  showLoginError(response){
    if(response['errors'].containsKey('invalid_username')){
      print('Incorrect Username');
    }
    else if(response['errors'].containsKey('incorrect_password')){
      print('Incorrect Password');
    }
  }
}
