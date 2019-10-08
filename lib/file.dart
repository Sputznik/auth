import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access to File and Directory classes


class fileHelper{


  // READS FILE CONTENTS AS STRING AND DECODES IT TO JSON FORMAT
  readFileContents() async{
    final file = File(getFileName());
    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    }
    return {};
  }

  // TAKES STRING INPUT AND WRITES INTO A FILE
  writeFileContents(contents) async{
    final file = File(getFileName());
    await file.writeAsString(contents);
  }

  String getFileName(){
    return Directory.systemTemp.path + "/steve1.json";
  }

}