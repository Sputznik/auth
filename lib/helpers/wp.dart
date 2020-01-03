//import 'package:flutter_wordpress/constants.dart';
import 'package:flutter_wordpress/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'wordpress/api.dart';
import 'wordpress/models.dart';

class Wordpress {
  //String baseUrl;

  //String appUserName = '';
  //String authKey = '';

  WordpressUser user;

  WordpressAPI api;

  //This creates the single instance by calling the `_internal` constructor specified below
  static final Wordpress _singleton = new Wordpress._internal();

  Wordpress._internal();

  //This is what's used to retrieve the instance through the app
  static Wordpress getInstance() => _singleton;

  void initialize(String baseUrl) {
    //this.baseUrl = baseUrl;
    this.api = WordpressAPI(baseUrl);
  }

  String getPostsUrl() => "wp-json/wp/v2/posts";

  String getMediaUrl() => "wp-json/wp/v2/media";

  String getAuthUrl() => "wp-admin/admin-ajax.php?action=auth_with_flutter";

  String getMeUrl() => "wp-json/wp/v2/users/me";

  createPost({@required postData, endPoint}) async {
    if (endPoint == null) {
      endPoint = getPostsUrl();
    }
    return await api.postResponse(endPoint: endPoint, body: postData, base64: user.authKey);
  }

  updatePost({@required postData, @required int postId, endPoint}) async {
    if (endPoint == null) {
      endPoint = getPostsUrl();
    }
    endPoint += "/" + postId.toString();
    return await api.postResponse(endPoint: endPoint, body: postData, base64: user.authKey);
  }

  deletePost(int postId) async {
    String endPoint = getPostsUrl() + "/" + postId.toString();
    return await api.deleteResponse(endPoint, user.authKey);
  }

  createMedia(File file) async {
    String url = api.baseUrl + getMediaUrl();
    String filename = basename(file.path);
    var bytes = file.readAsBytesSync();
    String base64 = this.user.authKey;

    final mimeTypeData = lookupMimeType(file.path, headerBytes: bytes);

    Map<String, String> headers = {
      'Authorization': 'Basic $base64',
      'Content-Disposition': 'form-data;filename="$filename"',
      'Content-type': '$mimeTypeData'
    };

    return await api.postResponse( endPoint:getMediaUrl(), body:file.readAsBytesSync(), headers:headers);
  }

  Future<List> getPosts({endPoint}) async {
    if (endPoint == null) {
      endPoint = getPostsUrl();
    }
    List posts = await api.getResponse(endPoint, user.authKey);
    return posts;
  }



  webLogin(String _username, String _password) async {
    final Map<String, dynamic> userInfo = {
      'ukey': base64.encode(utf8.encode(_username)),
      'pkey': base64.encode(utf8.encode(_password))
    };
    var $headers = {"Accept": "application/json"};
    return await api.postResponse( endPoint: getAuthUrl(), body: userInfo, headers: $headers);
  }

  // Stores the application password in shared preference
  saveAuthKeyToFile(Map appPass) async {

    if (appPass.containsKey('new_password') && appPass.containsKey('user') && appPass['user'].containsKey('user_login')) {

      // INIT VARIABLES
      Map userInfo = appPass['user'];
      String username = userInfo['user_login'];
      String password = appPass['new_password'];
      String authKey = base64Encode(utf8.encode(username + ":" + password));

      print(userInfo);

      // FETCH USER DETAILS FROM THE SERVER & SAVING TO FILE
      await setUserFromServer(authKey);


    }
  }

  disposeAuthKeyFromFile() async{
    final preference = await SharedPreferences.getInstance();
    preference.remove('wp_user');
  }

  // SET WORDPRESS USER FROM LOCAL FILE
  setUserFromFile() async {
    final preference = await SharedPreferences.getInstance();
    String userdata = preference.getString('wp_user');
    if(userdata != null){
      Map data = jsonDecode(userdata);
      this.user = WordpressUser(data);
    }
  }

  // SET WORDPRESS USER FROM SERVER
  setUserFromServer(authKey) async{
    Map serverUser = await api.getResponse(getMeUrl(), authKey);
    serverUser['authKey'] = authKey;
    this.user = WordpressUser(serverUser);

    // SAVING TO FILE
    final preference = await SharedPreferences.getInstance();
    preference.setString('wp_user', jsonEncode(this.user.toJson()));
  }

  // IN CASE THE INTERNET IS NOT THERE BUT THE AUTHKEY IS PRESENT THEN ALLOW THE USER TO BE AUTHENTICATED FOR THE TIME BEING
  Future<bool> hasValidAuthKey() async {

    print('checking for valid auth key');

    await setUserFromFile();

    //print('User details below');
    //print(this.user);

    if (this.user != null && this.user.authKey != null) {

      try{
        setUserFromServer(this.user.authKey);

        if(this.user.isValidUser()) return true;

      } on Exception catch(e){

        return true;

      }
    }
    return false;
  }
}

