//import 'package:flutter_wordpress/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:http_parser/src/media_type.dart';




class Wordpress{

  String baseUrl;

  //This creates the single instance by calling the `_internal` constructor specified below
  static final Wordpress _singleton = new Wordpress._internal();
  Wordpress._internal();

  //This is what's used to retrieve the instance through the app
  static Wordpress getInstance() => _singleton;

  void initialize(String baseUrl){
    this.baseUrl = baseUrl;
  }

  // TAKES THE HTTP RESPONSE AND RETURNS A JSON STRUCTURED LIST
  parseResponse(http.Response response){
    var jsonList;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      jsonList = json.decode(response.body);
    }
    return jsonList;
  }

  getResponse(endPoint) async{
    String url = baseUrl + endPoint;
    final response = await http.get(url, headers: getUrlHeaders());
    return parseResponse(response);
  }

  postResponse(endPoint, body, headers) async{
    String url = baseUrl + endPoint;
    final response = await http.post(url, body: body, headers: headers);
    return parseResponse(response);
  }

  deleteResponse(endPoint) async{
    String url = baseUrl + endPoint;
    final response = await http.delete(url, headers: getUrlHeaders());
    return parseResponse(response);
  }

  String getPostsUrl(){ return "wp/v2/posts"; }

  String getMediaUrl(){ return "wp/v2/media"; }

  String getBase64(){
    String username = 'samvthom16@gmail.com';
    String userkey = 'MqBM wtxS heJy 6swD 3c3k C5RL';
    return base64Encode(utf8.encode(username + ":" + userkey));
  }

  Map<String, String> getUrlHeaders(){
    String base64 = getBase64();
    return {
      'Accept': 'application/json',
      'Authorization': 'Basic $base64',
    };
  }

  createPost({@required postData, endPoint}) async{
    if(endPoint == null){
      endPoint = getPostsUrl();
    }
    return await postResponse(endPoint, postData, getUrlHeaders());
  }

  updatePost({@required postData, @required int postId, endPoint}) async{
    if(endPoint == null){
      endPoint = getPostsUrl();
    }
    endPoint += "/" + postId.toString();
    return await postResponse(endPoint, postData, getUrlHeaders());
  }

  deletePost(int postId) async{
    String endPoint = getPostsUrl() + "/" + postId.toString();
    return await deleteResponse(endPoint);
  }

  Future<ByteData> toByteData({ @required file, ImageByteFormat format = ImageByteFormat.rawRgba}) async{
    ByteData data;
    if (await file.exists()) {
      Uint8List encoded = await file.readAsBytes();
      data = encoded?.buffer?.asByteData();
    }
    return data;
  }


  createMedia(File file) async{

    String url = baseUrl + getMediaUrl();
    String filename = basename(file.path);
    var bytes = file.readAsBytesSync();
    String base64 = getBase64();

    final mimeTypeData = lookupMimeType(file.path, headerBytes: bytes);

    Map<String, String> headers = {
      'Authorization': 'Basic $base64',
      'Content-Disposition': 'form-data;filename="$filename"',
      'Content-type': '$mimeTypeData'
    };

    return await postResponse(getMediaUrl(), file.readAsBytesSync(), headers);

    /*
    http.post(url, body: file.readAsBytesSync(), headers: headers).then((res) {
      print(res.body);
    }).catchError((err) {
      print(err);
    });

     */







  }

  Future<List> getPosts({endPoint}) async{
    if(endPoint == null){
      endPoint = getPostsUrl();
    }
    List posts = await getResponse(endPoint);
    return posts;
  }

  void test() async{



    /*
    File file = File('/storage/emulated/0/Android/data/com.example.auth/files/Pictures/scaled_images.png');
    var response = await createMedia(file);
    print(response);


     */

    //print('test');

    //List posts = await getPosts();
    //print(posts);

    /*
    Map<String, dynamic> postData = {
      'title': 'Sample Post',
      'content': 'Sample Content',
      'status': 'draft'
    };
    var newPost = await createPost(postData: postData);
    print(newPost);
    */

  }

}