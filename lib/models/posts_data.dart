import 'package:auth/helpers/storage.dart';
import 'package:flutter/material.dart';
import 'package:auth/models/post_data.dart';
import 'package:auth/helpers/wp.dart';

class PostsCollection extends ChangeNotifier {
  List<PostData> _posts = [];

  List<PostData> get posts => _posts;

  InternalStorage store = InternalStorage('posts2.json');

  Future read() async {
    _posts = [];
    await store.readFileContents();
    List data = store.getContents();
    for (int i = 0; i < data.length; i++) {
      _posts.add(PostData(data[i]));
    }
    notifyListeners();
  }

  Future write() async {
    store.setContents(_posts);
    await store.writeFileContents();
  }

  void addItem(PostData post) {
    _posts.add(post);
    write();
    notifyListeners();
  }

  Future deleteItem(PostData post) async {
    if (post.id > 0) {
      await Wordpress.getInstance().deletePost(post.id);
    }
    _posts.remove(post);
    write();
    notifyListeners();
  }

  Future updateItem(PostData post) async{
    if (post.id > 0) {

      // UPLOAD ALL THE MEDIA ATTACHMENTS INCLUDING THE FEATURED IMAGE
      await post.uploadAttachments();

      // GET THE JSON DATA THAT NEEDS TO BE SENT TO THE SERVER
      final postData = post.getDataForUpload();

      // SEND TO SERVER
      await Wordpress.getInstance().updatePost(postData: postData, postId: post.id);
    }
    write();
  }

  String toString() {
    return _posts.toString();
  }

  Future publish(PostData post) async {
    if (post.id == 0) {
      // UPLOAD ALL THE MEDIA ATTACHMENTS INCLUDING THE FEATURED IMAGE
      await post.uploadAttachments();

      // GET THE JSON DATA THAT NEEDS TO BE SENT TO THE SERVER
      final data = post.getDataForUpload();

      //print(data);


      // SEND TO SERVER
      var response = await Wordpress.getInstance().createPost(postData: data);
      if(response.containsKey('id')){
        post.response = response;
        post.id = response['id'];
      }
    }
    write();
  }
}
