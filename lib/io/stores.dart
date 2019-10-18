import 'dart:io';

import 'package:auth/postdata.dart';

import 'package:path/path.dart';

import 'storage.dart';

class BaseStore{

  InternalStorage store;

  BaseStore(){
    store = InternalStorage('sample.json');
  }

  void setStoreContents(contents) => store.setContents(contents);

  Map getStoreContents() => store.getContents();

  Future<Map> read() async{
    await store.readFileContents();
    return getStoreContents();
  }

  Future write() async{
    await store.writeFileContents();
  }

  Future update(key, newContent) async{

    if(key == null || key == '') throw UnimplementedError('Empty Key');

    Map contents = getStoreContents();
    contents[key] = newContent;

    setStoreContents(contents);
    await write();
  }

  Future delete(String id) async {
    Map contents = getStoreContents();
    contents.remove(id);
    setStoreContents(contents);
    await write();
  }

}

class PostsStore extends BaseStore{

  PostsStore(){ store = InternalStorage('posts2.json'); }

  Future<String> saveAsPost(PostData post) async{
    await update(post.id, post.toJson());
    return post.id;
  }

}

class MediaStorage extends BaseStore{

  MediaStorage(){
    store = InternalStorage('medialib.json');
  }

  /*
  * CHECK IF THE LOCAL FILE EXISTS IN THE MEDIA STORAGE
  * IF YES AND THE NETWORK URL IS NOT EMPTY THEN PASS THE NETWORK URL
  * ELSE PASS THE LOCAL PATH OF THE FILE
  * */
  Future<String> saveAsMediaAttachment(MediaAttachment media) async {
    await update(media.id, media.toJson());
    return media.id;
  }

  // THERE NEEDS TO BE A CHECK DONE TO SEE IF THE LOCAL PATH IS MISSING THEN PULL THE IMAGE FROM THE NETWORK PATH FIRST
  String getLocalFilePath(String id){
    MediaAttachment mediaAttachment = getMediaAttachment(id);
    if(mediaAttachment != null){
      return mediaAttachment.getLocalFile().path;
    }
    return null;
  }

  MediaAttachment createMediaAttachment(File file){
    return MediaAttachment({
      'fileName' : basename(file.path),
      'localFile' : file.path
    });
  }

  MediaAttachment getMediaAttachment(String id){
    Map fileContents = getStoreContents();
    if(fileContents.containsKey(id)){
      return MediaAttachment(fileContents[id]);
    }
    return null;
  }

}