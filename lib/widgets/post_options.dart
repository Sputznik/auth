import 'package:flutter/material.dart';
import 'package:auth/models/post_data.dart';
import 'package:provider/provider.dart';
import 'package:auth/models/posts_data.dart';

class PostOptionsMenu extends StatefulWidget {

  final PostData post;

  final List hideActions;

  PostOptionsMenu({ @required this.post, this.hideActions });

  @override
  _PostOptionsState createState() => _PostOptionsState();
}

class _PostOptionsState extends State<PostOptionsMenu> {

  _PostOptionsState();

  Widget build(BuildContext context) {

    List hideActions = (widget.hideActions != null) ? widget.hideActions : [];

    //print(hideActions);

    List items = [
      {'label': 'Rename Title', 'icon': Icons.more, 'slug': 'rename'},
      {'label': 'Edit Article', 'icon': Icons.edit, 'slug': 'edit'},
      {'label': 'Set Featured Image', 'icon': Icons.image, 'slug': 'set-featured'},
      {'label': 'Delete', 'icon': Icons.delete, 'slug': 'delete'},
      {'label': 'Publish', 'icon': Icons.cloud_upload, 'slug': 'publish'},
    ];

    List<PopupMenuEntry<String>> popMenuItems = [];

    for(int i=0; i<items.length; i++){
      if( !hideActions.contains(items[i]['slug'])){
        popMenuItems.add(
          buildMenuItem(items[i]['label'], items[i]['icon'], items[i]['slug'])
        );
        //print(items[i]);
      }
    }

    /*
    // ADD PUBLISH ONLY FOR THOSE WHO HAVE NOT BEEN PUBLISHED BEFORE
    if (widget.post != null && widget.post.id == 0) {
      popMenuItems.add(buildMenuItem('Publish', Icons.cloud_upload, 'publish'));
    }
    */

    return PopupMenuButton(
      //icon: Icon(Icons.cloud_upload),
      itemBuilder: (BuildContext context) => popMenuItems,
      onSelected: (selectedItem) => onSelect(selectedItem),
    );
  }

  Future onSelect(String selectedItem) async{
    PostsCollection postsCollection =
    Provider.of<PostsCollection>(context, listen: false);

    PostData post = widget.post; //Provider.of<PostData>(context, listen: false);

    switch (selectedItem) {
      case 'rename':
        bool toUpdate = await post.actionRenameTitle(context);
        if(toUpdate){
          if(post.id > 0){ post.upload();}
          postsCollection.write();
        }
        //print('rename title');
        break;
      case 'edit':
        bool toUpdate = await post.actionEdit(context);
        if(toUpdate){
          if(post.id > 0){ post.upload();}
          postsCollection.write();
        }
        break;
      case "set-featured":
        await post.actionFeaturedImage(context);
        if(post.id > 0){ post.upload();}
        postsCollection.write();
        break;
      case "delete":
        if(post.id > 0){ post.deleteFromServer();}
        postsCollection.deleteItem(post);
        break;
      case "publish":
        await post.upload();
        postsCollection.write();
        break;
    }
  }

  Widget buildMenuItem(String label, IconData icon, String value) {
    return PopupMenuItem<String>(
        value: value,
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 5.0,
            ),
            Text(label)
          ],
        ));
  }
}
