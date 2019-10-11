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
    return Directory.systemTemp.path + "/test2.json";
  }

}

class PostData{
  String id;
  String title;
  NotusDocument content;
  DateTime created_at;

  PostData(String id, String title, DateTime created_at, content){
    this.id = id != "" ? id : getRandomID();
    this.created_at = created_at;
    setTitle(title);
    if(content.length>0){
      setContent(content);
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

  String getCreatedAt(){
    return timeago.format(created_at);
  }

  Map toJson(){
    return {
      "id"   : this.id,
      "title": this.title,
      "created_at": this.created_at.toIso8601String(),
      "content": this.content.toJson()
    };
  }

  String toString(){ return this.toJson().toString(); }

  saveToFile(fileContents) async{
    FileHelper helper = FileHelper();
    fileContents[this.id] = this.toJson();
    await helper.writeFileContents(fileContents);
  }


}