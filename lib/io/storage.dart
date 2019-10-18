import 'dart:convert'; // access to jsonEncode()
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui';

import 'package:flutter/services.dart'; // access to File and Directory classes


class InternalStorage{

  File file;
  String fileName;
  Map contents;

  InternalStorage(String fileName){
    this.fileName = Directory.systemTemp.path + "/" + fileName;
    this.file = File(getFileName());
    setContents({});
  }

  Map getContents() => this.contents;

  void setContents(contents) => this.contents = contents;

  // READS FILE CONTENTS AS STRING AND DECODES IT TO JSON FORMAT
  Future<Map> readFileContents() async {
    if (await file.exists()) {
      final contentsStr = await file.readAsString();
      setContents(jsonDecode(contentsStr));
    }
    return getContents();
  }

  // SET NEW CONTENTS BEFORE INVOKING THE FUNCTION
  // WRITES THE CONTENTS INTO THE FILE
  Future writeFileContents() async {
    await file.writeAsString(jsonEncode(getContents()));
  }

  Future<ByteData> toByteData({ImageByteFormat format = ImageByteFormat.rawRgba}) async{
    ByteData data;
    if (await file.exists()) {
      Uint8List encoded = await file.readAsBytes();
      data = encoded?.buffer?.asByteData();
    }
    return data;
  }

  String getFileName() { return this.fileName; }
}