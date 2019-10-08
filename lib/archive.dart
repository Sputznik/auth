import 'dart:convert';

import 'package:auth/file.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  String fileData;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive'),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
      body: (fileData) != null ? Text(fileData): Text('No posts found'),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/editor').then((value){
            
            fileHelper helper = fileHelper();
            helper.readFileContents().then((data){
              setState(() {
                data.forEach((k,v){
                  print(k);
                });
              });

              //data.forEach((key,value)) => print('${key}');

              //print(data.runtimeType);
            });
            
            
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
