import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:auth/models/wp_posts_model.dart';
import 'package:http/http.dart' as http;


//Future<String> loadWpAsset() async{
//  return await rootBundle.loadString('assets/json/wordpress.json');
//}

Future loadPosts(parsedData) async{
  //String jsonString = await loadWpAsset();
//  String url = 'https://ykasandbox.com/wp-json/wp/v2/posts?per_page=57';

//  var jsonString = await http.get(Uri.encodeFull(url),headers: {"type":"application/json"});

//  final jsonResponse = json.decode(jsonString.body);

  final jsonResponse = parsedData;

  WpPostsList postsList = WpPostsList.fromJson(jsonResponse);

  //  WpPost({this.postDate,this.postTitle,this.postExcerpt,this.postContent,this.postFeatured});
//  print('Post Title: ${postsList.posts[5].postTitle.title}');
//  print('Post Excerpt: ${postsList.posts[5].postExcerpt.excerpt}');
//  print('Post Content: ${postsList.posts[5].postContent.content}');
//  print('Post Featured Image: ${postsList.posts[5].postFeatured}');
//  print('Post Publish Date: ${postsList.posts[5].postDate}');
  //print(postsList.posts);
  return postsList.posts;
}