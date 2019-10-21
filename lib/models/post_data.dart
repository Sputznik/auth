import 'package:zefyr/zefyr.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import '../helpers/html.dart';
import 'package:path/path.dart';
import 'base_data.dart';
import 'media_data.dart';

class PostData extends BaseData {

  String id;

  String title;

  NotusDocument content;

  DateTime created_at;

  List<MediaAttachment> attachments;

  MediaAttachment featuredImage;

  PostData(Map data) {
    this.id = data.containsKey('id') ? data['id'] : getRandomID();
    this.created_at = data.containsKey('created_at')
        ? DateTime.parse(data['created_at'])
        : DateTime.now();

    this.featuredImage = MediaAttachment({});
    if (data.containsKey('featuredImage')) {
      this.featuredImage = MediaAttachment(data['featuredImage']);
    }

    this.attachments = [];
    if (data.containsKey('attachments') && data['attachments'] != null) {
      for(int i=0; i<data['attachments'].length; i++){
        attachments.add(MediaAttachment(data['attachments'][i]));
      }
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

  String getCreatedAt() => timeago.format(created_at);

  String getHtmlContent() {
    HtmlHelper html = HtmlHelper();
    return html.convertToHtml(content);
  }

  List<HtmlTag> getHtmlJson() {
    HtmlHelper html = HtmlHelper();
    return html.convertToJson(content);
  }

  /*
  Future getAttachments() async{

    MediaStorage mediaStorage = MediaStorage();

    await mediaStorage.read();

    Map mediaContents = mediaStorage.getStoreContents();

    //print(mediaContents);

    List<MediaAttachment> attachments = [];

    List<HtmlTag> tags = getHtmlJson();
    for (int i = 0; i < tags.length; i++) {

      if (tags[i].tag == 'img' && tags[i].attributes.containsKey('src')) {
        String mediaId  = tags[i].attributes['src'];

        MediaAttachment temp = mediaStorage.getMediaAttachment(mediaId);

        if(temp != null){
          attachments.add(temp);
        }

      }
    }

    print(attachments);

    //return attachments;
  }

  void uploadAttachments() async {
    MediaStorage mediaStorage = MediaStorage();
    await mediaStorage.read();

    List<MediaAttachment> attachments = []; //getAttachments();

    print('attachments');

    print(attachments);

    for (int i = 0; i < attachments.length; i++) {
      attachments[i].upload(mediaStorage);
    }
  }
  */

  Map toJson() {
    Map jsonObj = {
      "id": this.id,
      "title": this.title,
      "created_at": this.created_at.toIso8601String(),
      "content": this.content.toJson(),
      'attachments': this.attachments
    };

    if (this.featuredImage != null) {
      jsonObj['featuredImage'] = this.featuredImage.toJson();
    }

    return jsonObj;
  }

  MediaAttachment createMediaAttachmentFromFile(File file){
    return MediaAttachment({
      'fileName' : basename(file.path),
      'localFile' : file.path
    });
  }

  int addAttachment(MediaAttachment media){
    attachments.add(media);
    return attachments.indexOf(media);
  }

  MediaAttachment getEachAttachment(int index){
    if (index < attachments.length){
      return attachments[index];
    }
    return null;
  }
}

