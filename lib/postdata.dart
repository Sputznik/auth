import 'dart:convert';


import 'package:zefyr/zefyr.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import 'html.dart';

import "io/stores.dart";

class BaseData {
  String id;

  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  Map toJson() => {};

  String toString() => this.toJson().toString();

}

class PostData extends BaseData {

  String id;

  String title;

  NotusDocument content;

  DateTime created_at;

  File featuredImage;

  PostData(Map data) {
    this.id = data.containsKey('id') ? data['id'] : getRandomID();
    this.created_at = data.containsKey('created_at')
        ? DateTime.parse(data['created_at'])
        : DateTime.now();

    if (data.containsKey('featuredImage')) {
      setFeaturedImage(File(data['featuredImage']));
    }

    // SET TITLE OF THE POST
    data['title'] = data.containsKey('title') ? data['title'] : "Untitled";
    setTitle(data['title']);

    // SET CONTENT OF THE POST
    data['content'] = data.containsKey('content') ? data['content'] : [];
    if (data['content'].length > 0) {
      setContent(data['content']);
    } else {
      // IF EMPTY LIST IS PASSED THEN SET CONTENT BY DEFAULT VALUE
      setContent([
        {"insert": "\n"}
      ]);
    }
  }

  void setTitle(String title) => this.title = title;

  String getTitle() => this.title;

  void setContent(List content) =>
      this.content = NotusDocument.fromJson(content);

  NotusDocument getContent() => this.content;

  File getFeaturedImage() => this.featuredImage;

  void setFeaturedImage(File featuredImage) =>
      this.featuredImage = featuredImage;

  String getCreatedAt() => timeago.format(created_at);

  String getHtmlContent() {
    HtmlHelper html = HtmlHelper();
    return html.convertToHtml(content);
  }

  List<HtmlTag> getHtmlJson() {
    HtmlHelper html = HtmlHelper();
    return html.convertToJson(content);
  }

  List<MediaAttachment> getAttachments(mediaStorage) {
    Map mediaContents = mediaStorage.getStoreContents();
    List<MediaAttachment> attachments = [];
    /*
    List<HtmlTag> tags = getHtmlJson();
    for (int i = 0; i < tags.length; i++) {

      if (tags[i].tag == 'img' && tags[i].attributes.containsKey('src')) {
        String media_id  = tags[i].attributes['src'];

        MediaAttachment temp = mediaStorage.getMediaAttachment(media_id);

        if(temp != null){
          attachments.add(temp);
        }

      }
    }
    */
    return attachments;
  }

  void uploadAttachments() async {
    MediaStorage mediaStorage = MediaStorage();
    await mediaStorage.read();

    List<MediaAttachment> attachments = getAttachments(mediaStorage);

    print('attachments');

    print(attachments);

    for (int i = 0; i < attachments.length; i++) {
      attachments[i].upload(mediaStorage);
    }
  }



  Map toJson() {
    Map jsonObj = {
      "id": this.id,
      "title": this.title,
      "created_at": this.created_at.toIso8601String(),
      "content": this.content.toJson(),
    };

    if (this.featuredImage != null && this.featuredImage.path != "") {
      jsonObj['featuredImage'] = this.featuredImage.path;
    }

    return jsonObj;
  }


}

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
    return {
      'id': id,
      'fileName': fileName,
      'localFile': localFile.path,
      'networkUrl': networkUrl
    };
  }

  // SEND TO SERVER
  Future upload(MediaStorage mediaStorage) async {

    // TEST RUN THAT THE SERVER WILL RETURN AN OBJECT WHICH WILL CONTAIN THE NETWORK URL OF THE FILE
    await Future.delayed(const Duration(milliseconds: 500));
    setNetworkUrl("https://churchbuzz.in/wp-content/uploads/2019/08/zekeriya-sen-zY7ArPAVino-unsplash-e1567068913528.jpg");

    // SAVE THE NEW NETWORK URL TO THE LOCAL SYSTEM
    await mediaStorage.saveAsMediaAttachment(this);


  }


}
