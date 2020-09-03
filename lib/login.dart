import 'dart:convert';

import 'helpers/wp.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final bool autologin;

  LoginPage({@required this.autologin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool loadingFlag = false;

  bool isVisible = false;

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //print('widget.autologin');
    //print(widget.autologin);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: widget.autologin ? buildAutoLoginWidget() : buildForm(),
      ),
    );
  }

  Widget buildAutoLoginWidget() {
    return Stack(
      children: <Widget>[
        Opacity(opacity: 0.5, child: buildForm()),
        Container(
          alignment: Alignment.center,
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: <Widget>[
            buildFormHeading(),
            SizedBox(height: 20.0),
            buildTextFormField('username'),
            SizedBox(height: 20.0),
            buildTextFormField('password'),
            SizedBox(height: 20.0),
            buildFormButton(),
          ],
        ),
      ),
    );
  }

  Widget buildFormButton() {
    return RaisedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        loginBtnClick();
      },
      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: loadingFlag
          ? loadingIcon()
          : Text('Login',
          style: TextStyle(color: Colors.white, fontSize: 15.0)),
    );
  }

  // ENABLED WHEN THE LOADING FLAG IS TRUE
  Widget loadingIcon() {
    return Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ));
  }

  // GET THE SNACKBAR FOR ERROR
  Widget snackbarError(response) {
    Widget snackBar;
    if (response['errors'].containsKey('invalid_username')) {
      snackBar = SnackBar(content: Text('Invalid Username!'));
    } else if (response['errors'].containsKey('incorrect_password')) {
      snackBar = SnackBar(content: Text('Incorrect Password!'));
    }
    return snackBar;
  }

  Widget buildTextFormField(type) {
    String validateText = '';
    String label = '';
    TextInputType textInputType = TextInputType.text;
    TextEditingController controller;
    bool obscureTextFlag = false;
    Icon icon = Icon(Icons.person);
    Widget suffIcon;

    switch (type) {
      case 'password':
        label = 'Password';
        validateText = 'Password cannot be empty';
        controller = _passwordController;
        obscureTextFlag = isVisible ? false : true;
        icon = Icon(Icons.lock);
        suffIcon = GestureDetector(
          child: isVisible
              ? Icon(Icons.visibility, color: Colors.red)
              : Icon(Icons.visibility_off, color: Colors.grey),
          onTap: () {
            setState(() => isVisible = !isVisible);
          },
        );
        break;
      case 'username':
        label = 'Email/Username';
        validateText = 'Username cannot be empty';
        textInputType = TextInputType.emailAddress;
        controller = _emailController;
        break;
    }

    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return validateText;
        }
        return null;
      },
      keyboardType: textInputType,
      controller: controller,
      cursorColor: Colors.red,
      obscureText: obscureTextFlag,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        labelText: label,
        prefixIcon: icon,
        suffixIcon: suffIcon != null ? suffIcon : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  // ENABLE THE LOADER
  showLoaderOnBtn() {
    setState(() {
      loadingFlag = true;
    });
  }

  // DISABLE THE LOADER
  hideLoaderBtn() {
    setState(() {
      loadingFlag = false;
    });
  }

  loginBtnClick() async {
    Wordpress wp = Wordpress.getInstance();
    String username = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState.validate()) {
      // SHOW LOADER
      showLoaderOnBtn();

      // GET THE APPLICATION PASSWORD FROM THE SERVER
      Map appPass = await wp.webLogin(username, password);
      print('App details:');
      print(appPass);

      // HIDE LOADER
      hideLoaderBtn();

      // SAVE THE NEWLY ACQUIRED AUTH KEY
      await wp.saveAuthKeyToFile(appPass);

      if (appPass.containsKey('errors')) {
        // Show SnackBar if the username/password is not valid
        _scaffoldKey.currentState.showSnackBar(snackbarError(appPass));
      } else {
        // RESET FORM
        resetForm();

        // REDIRECT TO THE NEXT SCREEN
        Navigator.pushReplacementNamed(context, 'topics');
      }
    }
  }

  // CLEAR THE FORM
  resetForm() {
    _emailController.clear();
    _passwordController.clear();
  }

  Widget buildFormHeading() {
    return Text(
      'Login'.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.grey[900],
      ),
    );
  }
}
