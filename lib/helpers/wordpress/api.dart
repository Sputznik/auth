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


class WordpressAPI{

  String baseUrl;

  WordpressAPI(this.baseUrl);

  Map<String, String> getUrlHeaders(base64) {

    Map<String, String> headers = { 'Accept': 'application/json', };

    if(base64 != null && base64.length > 0){
      headers['Authorization'] = 'Basic $base64';
    }

    return headers;
  }

  // TAKES THE HTTP RESPONSE AND RETURNS A JSON STRUCTURED LIST
  parseResponse(http.Response response) {
    var jsonList;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      jsonList = json.decode(response.body);
    }
    return jsonList;
  }

  getResponse(endPoint, base64) async {
    String url = baseUrl + endPoint;
    final response = await http.get(url, headers: getUrlHeaders(base64));
    return parseResponse(response);
  }

  postResponse({@required endPoint, @required body, base64, headers }) async {
    if(headers == null && base64 != null){
      headers = getUrlHeaders(base64);
    }
    String url = baseUrl + endPoint;
    final response = await http.post(url, body: body, headers: headers);
    return parseResponse(response);
  }

  deleteResponse(endPoint, base64) async {
    String url = baseUrl + endPoint;
    final response = await http.delete(url, headers: getUrlHeaders(base64));
    return parseResponse(response);
  }



}