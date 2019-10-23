import 'package:auth/helpers/wp.dart';

import 'base_data.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class MediaAttachment extends BaseData {
  int id;

  String fileName;

  File localFile;

  String networkUrl;

  Map response;

  MediaAttachment(Map data) {
    this.id = data.containsKey('id') ? data['id'] : 0;

    if (data.containsKey('fileName')) {
      this.fileName = data['fileName'];
    }

    if (data.containsKey('localFile')) {
      setLocalFile(File(data['localFile']));
    }

    if (data.containsKey('networkUrl')) {
      setNetworkUrl(data['networkUrl']);
    }

    if (data.containsKey('response')) {
      this.response = data['response'];
    }
  }

  File getLocalFile() => this.localFile;

  void setLocalFile(localFile) => this.localFile = localFile;

  String getNetwrkUrl() => this.networkUrl;

  void setNetworkUrl(networkUrl) => this.networkUrl = networkUrl;

  Map toJson() {
    Map jsonObj = {'id': id, 'fileName': fileName, 'networkUrl': networkUrl};

    if (this.localFile != null && this.localFile.path != null) {
      jsonObj['localFile'] = this.localFile.path;
    }

    if (response != null) {
      jsonObj['response'] = this.response;
    }

    return jsonObj;
  }

  // RETURN IMAGE WIDGET
  ImageProvider buildImage(BuildContext context) {
    ImageProvider imageProvider;
    imageProvider = AssetImage('assets/default.png');
    if (localFile != null) {
      imageProvider = FileImage(localFile);
    }
    return imageProvider;
  }

  /*
   * 1. SEND TO SERVER ONLY IF LOCAL FILE IS VALID
   * 2. SAVE THE RESPONSE
   * 3. SET THE NETWORK URL
   */
  Future upload() async {
    if (localFile != null && this.id == 0) {
      print('media upload');
      var response = await Wordpress.getInstance().createMedia(localFile);
      this.response = response;
      if (response.containsKey('guid') &&
          response['guid'].containsKey('rendered') &&
          response.containsKey('id')) {
        this.id = response['id'];
        this.networkUrl = response['guid']['rendered'];
      }
    }
  }
}
