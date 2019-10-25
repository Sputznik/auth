import 'dart:collection';
import 'package:auth/helpers/storage.dart';
import 'package:flutter/material.dart';
import 'package:auth/models/post_data.dart';

class PostsCollection extends ChangeNotifier {
  List<PostData> _posts = [];

  bool isLoading = false;

  List<PostData> get posts => UnmodifiableListView(_posts.reversed.toList());

  InternalStorage store = InternalStorage('posts2.json');

  Future read() async {
    _posts = [];
    await store.readFileContents();
    List data = store.getContents();
    for (int i = 0; i < data.length; i++) {
      _posts.add(PostData(data[i]));
    }
    //await Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  Future write() async {
    store.setContents(_posts);
    await store.writeFileContents();
  }

  Future addItem(PostData post) async{
    print(_posts.runtimeType);
    _posts.add(post);
    await write();
    notifyListeners();
  }

  Future deleteItem(PostData post) async {
    _posts.remove(post);
    write();
    notifyListeners();
  }

  String toString() {
    return _posts.toString();
  }


}
