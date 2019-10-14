import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access to File and Directory classes
import 'package:zefyr/zefyr.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

class FileHelper{

  // READS FILE CONTENTS AS STRING AND DECODES IT TO JSON FORMAT
  readFileContents() async{
    final file = File(getFileName());
    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    }
    return {};
  }

  // TAKES JSON INPUT AND WRITES INTO A FILE
  writeFileContents(contents) async{
    final file = File(getFileName());
    await file.writeAsString(jsonEncode(contents));
  }

  String getFileName(){
    return Directory.systemTemp.path + "/test3.json";
  }

}

class PostData{
  String id;
  String title;
  NotusDocument content;
  DateTime created_at;

  File featuredImage;

  PostData(Map data){
    this.id = data.containsKey('id') ? data['id'] : getRandomID();
    this.created_at = data.containsKey('created_at') ? DateTime.parse(data['created_at']) : DateTime.now();

    if(data.containsKey('featuredImage')){
      //print(data['featuredImage'].length);
      setFeaturedImage(File(data['featuredImage']));
    }

    // SET TITLE OF THE POST
    data['title'] = data.containsKey('title') ? data['title'] : "Untitled";
    setTitle(data['title']);

    // SET CONTENT OF THE POST
    data['content'] = data.containsKey('content') ? data['content'] : [];
    if(data['content'].length>0){
      setContent(data['content']);
    }
    else{
      // IF EMPTY LIST IS PASSED THEN SET CONTENT BY DEFAULT VALUE
      setContent([{"insert": "\n"}]);
    }

  }

  String getRandomID() {
    var rng = new Random();
    return base64.encode([rng.nextInt(10), rng.nextInt(10)]);
  }

  void setTitle(String title){ this.title = title; }
  String getTitle(){ return this.title;}

  void setContent(List content){ this.content = NotusDocument.fromJson(content); }
  NotusDocument getContent(){ return this.content;}

  File getFeaturedImage(){ return this.featuredImage;}
  void setFeaturedImage(File featuredImage){ this.featuredImage = featuredImage; }

  String getCreatedAt(){
    return timeago.format(created_at);
  }

  Map toJson(){

    Map jsonObj = {
      "id"   : this.id,
      "title": this.title,
      "created_at": this.created_at.toIso8601String(),
      "content": this.content.toJson(),
    };

    if( this.featuredImage !=null && this.featuredImage.path != "" ){
      jsonObj['featuredImage'] = this.featuredImage.path;
    }

    return jsonObj;
  }

  String toString(){ return this.toJson().toString(); }

  saveToFile(fileContents) async{
    FileHelper helper = FileHelper();
    fileContents[this.id] = this.toJson();
    await helper.writeFileContents(fileContents);
  }

  delete(fileContents) async{
    FileHelper helper = FileHelper();
    fileContents.remove(this.id);
    await helper.writeFileContents(fileContents);
  }




}