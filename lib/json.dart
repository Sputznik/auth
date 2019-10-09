import 'package:auth/zefyr_editor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'file.dart';

class JsonConvert extends StatefulWidget {
  @override
  _JsonConvertState createState() => _JsonConvertState();
}

class _JsonConvertState extends State<JsonConvert> {
  List data = [];

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.red[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openEditor("");
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        itemCount: (data) == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(data[index]),
              ),
            ),
            onTap: () {
              //print(data[index]);
              openEditor(data[index]);
            },
          );
        },
      ),
    );
  }

  void openEditor(id) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(id))).then((value) {
      if (value) {
        getData();
      }
    });
  }

  Future<String> getData() async {
    fileHelper helper = fileHelper();
    data = [];
    helper.readFileContents().then((value) {
      print(value);

      // REBUILD THE UI WHEN DATA HAS BEEN UPDATED
      setState(() {
        value.forEach((k, v) {
          data.add(k);
        });
        //print(data);
      });
    });
    return 'Success';
  }
}
