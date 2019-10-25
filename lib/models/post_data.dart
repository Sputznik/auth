import 'package:auth/helpers/wp.dart';
import 'package:flutter/cupertino.dart';
import 'package:zefyr/zefyr.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import '../helpers/html.dart';
import 'package:path/path.dart';
import 'base_data.dart';
import 'media_data.dart';
import '../widgets/image_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:auth/editor_view.dart';

class PostData extends BaseData with ChangeNotifier{

  int id;

  String title;

  NotusDocument content;

  DateTime created_at;

  List<MediaAttachment> attachments;

  MediaAttachment featuredImage;

  Map response;

  bool isLoading = false;

  PostData(Map data) {
    this.id = data.containsKey('id') ? data['id'] : 0;
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

    if(data.containsKey('response')){
      this.response = data['response'];
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

  // GETS THE ATTACHMENTS THAT ARE ACTUALLY EMBEDDED INSIDE THE DOCUMENT
  List<MediaAttachment> getInlineAttachments(){
    List<MediaAttachment> inlineAttachments = [];

    List<HtmlTag> tags = getHtmlJson();
    for (int i = 0; i < tags.length; i++) {
      if (tags[i].tag == 'img' && tags[i].attributes.containsKey('src')) {
        String mediaId  = tags[i].attributes['src'];
        int index = int.parse(mediaId);

        MediaAttachment temp = getEachAttachment(index);
        if(temp != null){
          inlineAttachments.add(temp);
        }
      }
    }
    inlineAttachments.add(this.featuredImage);
    return inlineAttachments;
  }

  Future uploadAttachments() async {
    List<MediaAttachment> attachments = getInlineAttachments();
    for (int i = 0; i < attachments.length; i++) {
      await attachments[i].upload();
    }
  }

  // REPLACE IMAGE TAG SOURCES WITH NETWORK URLS, SHOULD BE CALLED ONLY AFTER THE MEDIA ATTACHMENTS ARE UPDATED
  List<HtmlTag> prepareHtmlTagsForUpload(){

    List<HtmlTag> tags = getHtmlJson();
    for (int i = 0; i < tags.length; i++) {
      if (tags[i].tag == 'img' && tags[i].attributes.containsKey('src')) {
        String mediaId  = tags[i].attributes['src'];
        int index = int.parse(mediaId);

        MediaAttachment temp = getEachAttachment(index);
        if(temp != null && temp.networkUrl != null){
          tags[i].attributes['src'] = temp.networkUrl;
        }
        else{
          // IF OBJECT IF EMPTY/NULL THEN BETTER REMOVE THAT FROM THE TREE
          tags.removeAt(i);
        }
      }
    }

    return tags;
  }

  /*
   * MAKE SURE THIS FUNCTION IS CALLED AFTER THE INLINE ATTACHMENTS ARE UPLOADED
   *  */
  getDataForUpload(){

    HtmlHelper html = HtmlHelper();
    List<HtmlTag> tags = prepareHtmlTagsForUpload();
    String textHtml = html.convertListToHtml(tags);

    Map data = {
      'title': title,
      'content': textHtml,
      'status': 'draft'
    };

    if(featuredImage != null && featuredImage.id != null && featuredImage.id > 0){
      data['featured_media'] = featuredImage.id.toString();
    }

    return data;
  }

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

    if (this.response != null) {
      jsonObj['response'] = this.response;
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

  Future actionFeaturedImage(context) async{
    isLoading = true;
    notifyListeners();

    var newImage = await showDialog(
      context: context,
      builder: (BuildContext context) => ImagePickerDialog(),
    );

    if (newImage != null) {
      isLoading = false;
      featuredImage = createMediaAttachmentFromFile(newImage);

    }
    notifyListeners();
  }

  Future<bool> actionEdit(context) async{

    // TAKE A SNAPSHOT OF THE DATA AS STRING BEFORE IT IS SENT TO THE EDITOR
    String oldPostData = toString();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPage(this),
      ),
    );

    if (toString() != oldPostData) return true;
    return false;
  }

  Future<void> deleteFromServer() async{
    if (id > 0) {
      await Wordpress.getInstance().deletePost(id);
    }
  }

  Future<void> upload() async{
    // UPLOAD ALL THE MEDIA ATTACHMENTS INCLUDING THE FEATURED IMAGE
    await uploadAttachments();

    // GET THE JSON DATA THAT NEEDS TO BE SENT TO THE SERVER
    final postData = getDataForUpload();

    if (id > 0) { // NOT THE FIRST TIME
      // SEND TO SERVER
      await Wordpress.getInstance().updatePost(postData: postData, postId: id);
    }
    else{
      // SEND TO SERVER FOR THE FIRST TIME
      var response = await Wordpress.getInstance().createPost(postData: postData);
      if(response.containsKey('id')){
        response = response;
        id = response['id'];
      }
    }
  }

}

