import 'package:auth/helpers/storage.dart';
import 'package:flutter/material.dart';

import 'package:auth/models/post_data.dart';

class PostsCollection extends ChangeNotifier {
  List<PostData> _posts = [];

  List<PostData> get posts => _posts;

  InternalStorage store = InternalStorage('posts2.json');

  Future read() async{
    _posts = [];
    await store.readFileContents();
    Map fileContents = store.getContents();
    fileContents.forEach((k, v) {
      _posts.add(PostData(v));
    });
    notifyListeners();
  }

  Future write() async{
    Map fileContents = {};
    for(int i=0; i<_posts.length; i++){
      fileContents[_posts[i].id] = _posts[i];
    }
    store.setContents(fileContents);
    await store.writeFileContents();
  }

  void addItem(PostData post) {
    _posts.add(post);
    write();
    notifyListeners();
  }

  void deleteItem(PostData post) {
    bool flag = _posts.remove(post);
    write();
    notifyListeners();
  }

  void updateItem(PostData post){
    write();
  }

  String toString(){
    return _posts.toString();
  }
}