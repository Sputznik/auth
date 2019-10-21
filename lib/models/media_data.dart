import 'base_data.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class MediaAttachment extends BaseData {
  String id;

  String fileName;

  File localFile;

  String networkUrl;

  MediaAttachment(Map data) {
    this.id = data.containsKey('id') ? data['id'] : getRandomID();

    this.fileName = data.containsKey('fileName') ? data['fileName'] : "item";

    if (data.containsKey('localFile')) {
      setLocalFile(File(data['localFile']));
    }

    if (data.containsKey('networkUrl')) {
      setNetworkUrl(data['networkUrl']);
    }
  }

  File getLocalFile() => this.localFile;

  void setLocalFile(localFile) => this.localFile = localFile;

  String getNetwrkUrl() => this.networkUrl;

  void setNetworkUrl(networkUrl) => this.networkUrl = networkUrl;

  Map toJson() {

    Map jsonObj = {
      'id': id,
      'fileName': fileName,
      'networkUrl': networkUrl
    };

    if (this.localFile != null && this.localFile.path !=null) {
      jsonObj['localFile'] = this.localFile.path;
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


  // SEND TO SERVER
  Future upload() async {

    // TEST RUN THAT THE SERVER WILL RETURN AN OBJECT WHICH WILL CONTAIN THE NETWORK URL OF THE FILE
    await Future.delayed(const Duration(milliseconds: 500));
    setNetworkUrl("https://churchbuzz.in/wp-content/uploads/2019/08/zekeriya-sen-zY7ArPAVino-unsplash-e1567068913528.jpg");

  }




}
