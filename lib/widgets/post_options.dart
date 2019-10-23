import 'package:flutter/material.dart';
import 'package:auth/models/post_data.dart';

class PostOptionsMenu extends StatefulWidget {
  final PostData post;

  final Function onSelected;

  PostOptionsMenu(this.onSelected, this.post);

  @override
  _PostOptionsState createState() =>
      _PostOptionsState(this.onSelected, this.post);
}

class _PostOptionsState extends State<PostOptionsMenu> {
  final Function onSelected;

  final PostData post;

  _PostOptionsState(this.onSelected, this.post);

  Widget build(BuildContext context) {
    List<PopupMenuEntry<String>> popMenuItems = [
      buildMenuItem('Edit', Icons.edit, 'edit'),
      buildMenuItem('Set Featured Image', Icons.image, 'set-featured'),
      buildMenuItem('Delete', Icons.delete, 'delete'),
    ];

    // ADD PUBLISH ONLY FOR THOSE WHO HAVE NOT BEEN PUBLISHED BEFORE
    if (post != null && post.id == 0) {
      popMenuItems.add(buildMenuItem('Publish', Icons.cloud_upload, 'publish'));
    }

    return PopupMenuButton(
      itemBuilder: (BuildContext context) => popMenuItems,
      onSelected: (selectedItem) => this.onSelected(selectedItem),
    );
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
