import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access to File and Directory classes
import 'package:zefyr/zefyr.dart';
import 'dart:math';

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
    return Directory.systemTemp.path + "/test1.json";
  }

}

class PostData{
  String id;
  String title;
  NotusDocument content;

  PostData(id, String title, content){
    this.id = id != "" ? id : getRandomID();
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

  Map toJson(){
    return {
      "id"   : this.id,
      "title": this.title,
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