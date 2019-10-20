import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerDialog extends StatelessWidget {

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose An Image'),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: Container(
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            InkWell(
              child: Text("Take photo"),
              onTap: () {
                openCamera().then((newImage){
                  Navigator.of(context).pop(newImage);
                });
              },
            ),
            SizedBox(height: 20.0),
            InkWell(
              child: Text("Choose from gallery"),
              onTap: () {
                openGallery().then((newImage){
                  Navigator.of(context).pop(newImage);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<File> openGallery() async =>
      await ImagePicker.pickImage(source: ImageSource.gallery);

  Future<File> openCamera() async =>
      await ImagePicker.pickImage(source: ImageSource.camera);

}