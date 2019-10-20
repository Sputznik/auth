import 'package:flutter/material.dart';

class PostOptionsMenu extends StatefulWidget{

  final Function onSelected;

  PostOptionsMenu(this.onSelected);

  @override
  _PostOptionsState createState() => _PostOptionsState(this.onSelected);
}

class _PostOptionsState extends State<PostOptionsMenu>{

  final Function onSelected;

  _PostOptionsState(this.onSelected);

  Widget build(BuildContext context){
    return PopupMenuButton(
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: <Widget>[
                Icon(Icons.edit),
                SizedBox(width: 5.0,),
                Text("Edit")
              ],
            )),
        PopupMenuItem<String>(
            value: 'set-featured',
            child: Row(
              children: <Widget>[
                Icon(Icons.image),
                SizedBox(width: 5.0,),
                Text("Set Featured Image")
              ],
            )),
        PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: <Widget>[
                Icon(Icons.delete),
                SizedBox(width: 5.0,),
                Text("Delete")
              ],

            )),
        PopupMenuItem<String>(
            value: 'publish',
            child: Row(
              children: <Widget>[
                Icon(Icons.cloud_upload),
                SizedBox(width: 5.0,),
                Text("Publish")
              ],
            )),
      ],
      onSelected: (selectedItem) =>  this.onSelected(selectedItem),
    );
  }

}