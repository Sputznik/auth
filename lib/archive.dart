import 'dart:convert';

import 'package:auth/file.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List fileData = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive'),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
      body: (fileData) != null
          ? ListView.builder(
              itemCount: fileData.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){

                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(fileData[index]),
                    ),
                  ),
                );
              })
          : Text('No posts found'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/editor').then((value) {
//            fileHelper helper = fileHelper();
//            helper.readFileContents().then((data) {
//              print('Init State in archive');
//              print(fileData);
//              data.forEach((k, v) {
//                this.fileData.add(k);
//              });
//
//              //data.forEach((key,value)) => print('${key}');
//
//              //print(data.runtimeType);
//            });
          });
          print('button clicked');
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
