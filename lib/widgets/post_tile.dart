import 'dart:ui';
import 'package:auth/editor_view.dart';
import 'package:flutter/material.dart';
import '../models/post_data.dart';
import 'post_options.dart';
import 'image_cover.dart';
import 'image_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:auth/models/posts_data.dart';
import 'package:auth/helpers/wp.dart';

class PostTile extends StatefulWidget {
  final PostData post;
  PostTile({@required this.post});

  @override
  _PostTileState createState() => _PostTileState(this.post);
}

class _PostTileState extends State<PostTile> {
  PostData post;

  _PostTileState(this.post);

  Widget build(BuildContext context) {

    if (post != null) {

      //print(post.featuredImage);
      //post.upload();
      return buildItem(context);
    }
    return SizedBox.shrink();
  }

  Widget buildItem(context) {

    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ImageCoverWidget( media: post.featuredImage, width: 120, height: 120,),
              Container(
                width: 195,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildPostTitle(context),
                    SizedBox(height: 5.0),
                    buildPostExcerpt(context),
                    SizedBox(height: 20.0),
                    buildPostDate(context),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                width: 30,
                child: PostOptionsMenu(onSelectedOption),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildPostTitle(context){
    return Text(
      post.getTitle().toUpperCase(),
      style:
      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildPostExcerpt(context){
    return Text(
      post.getContent().toPlainText().replaceAll('\n', ' '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildPostDate(context){
    return Text(
        post.getCreatedAt(),
        style: TextStyle(fontWeight: FontWeight.w300)
    );
  }

  void onSelectedOption(selectedItem) {

    PostsCollection postsCollection = Provider.of<PostsCollection>(context, listen:false);

    switch (selectedItem) {
      case 'edit':
        openEditor();
        break;
      case "set-featured":
        showDialog(
                context: context,
                builder: (BuildContext context) => ImagePickerDialog())
            .then((newImage) {
          if (newImage != null) {
            setState(() {
              post.featuredImage = post.createMediaAttachmentFromFile(newImage);
            });
            postsCollection.updateItem(post);
          }
        });
        break;
      case "delete":

        postsCollection.deleteItem(post);

        setState(() {
          post = null;
        });

        break;
      case "publish":
        /*
         * OPERATION TO SEND TO API AND GET IT PUBLISHED USING WP API
         */
        break;
    }
  }

  /*
  * OPENS THE EDITOR
  * WAITS FOR THE POP EVENT
  * SAVES THE NEW POST RECEIVED & REBUILDS THE UI ONLY IF THE UPDATED POST HAS CHANGED
  */
  void openEditor() async {
    // TAKE A SNAPSHOT OF THE DATA AS STRING BEFORE IT IS SENT
    String oldPostData = post.toString();

    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditorPage(post)))
        .then((newPost) {
      if (newPost.toString() != oldPostData) {

        // REBUILD THE UI
        setState(() {
          post = newPost;
        });

        Provider.of<PostsCollection>(context, listen:false).updateItem(post);
      }
    });
  }
}
