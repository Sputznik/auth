import 'dart:convert';
import 'package:auth/storage.dart';

import 'package:zefyr/zefyr.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import 'html.dart';


class PostData {
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

  void setContent(List content) => this.content = NotusDocument.fromJson(content);

  NotusDocument getContent() => this.content;

  File getFeaturedImage() => this.featuredImage;

  void setFeaturedImage(File featuredImage) => this.featuredImage = featuredImage;

  String getCreatedAt() => timeago.format(created_at);

  String toString() => this.toJson().toString();

  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  String getHtmlContent() {
    HtmlHelper html = HtmlHelper();
    return html.convertToHtml(content);
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


  void saveToFile(InternalStorage internalStorage) async {
    Map contents = internalStorage.getContents();
    contents[this.id] = this.toJson();
    await _writeToFile(internalStorage, contents);
  }

  void delete(InternalStorage internalStorage) async {
    Map contents = internalStorage.getContents();
    contents.remove(this.id);
    await _writeToFile(internalStorage, contents);
  }

  Future _writeToFile(InternalStorage internalStorage, Map newContent) async{
    internalStorage.setContents(newContent);
    await internalStorage.writeFileContents();
  }
}
