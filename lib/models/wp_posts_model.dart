//Posts List Model (To be called for getting details on frontend)
class WpPostsList {
  final List<WpPost> posts;

  WpPostsList({this.posts});

  factory WpPostsList.fromJson(List<dynamic> parsedJson) {
    List<WpPost> postsList = parsedJson.map((i) => WpPost.fromJson(i)).toList();

    return WpPostsList(posts: postsList);
  }
}

//Posts Model
class WpPost {
  final DateTime postDate;
  PostTitle postTitle;
  final PostExcerpt postExcerpt;
  final PostContent postContent;
  final String postFeatured;

  WpPost(
      {this.postDate,
      this.postTitle,
      this.postExcerpt,
      this.postContent,
      this.postFeatured});

  factory WpPost.fromJson(Map<String, dynamic> posts) {
    return WpPost(
      postDate: publishedAt(posts['date']),
      postTitle: PostTitle.fromJson(posts['title']),
      postExcerpt: PostExcerpt.fromJson(posts['excerpt']),
      postContent: PostContent.fromJson(posts['content']),
      postFeatured: posts['featured_image'].toString(),
    );
  }

  static publishedAt(String published) {
    return DateTime.parse(published);
  }
}

//Posts Title Model
class PostTitle {
  final String title;

  PostTitle({this.title});

  factory PostTitle.fromJson(Map<String, dynamic> post) {
    return PostTitle(title: post['rendered']);
  }
}

//Posts Excerpt Model
class PostExcerpt {
  final String excerpt;

  PostExcerpt({this.excerpt});

  factory PostExcerpt.fromJson(Map<String, dynamic> post) {
    return PostExcerpt(excerpt: post['rendered']);
  }
}

//Posts Content Model
class PostContent {
  final String content;

  PostContent({this.content});

  factory PostContent.fromJson(Map<String, dynamic> post) {
    return PostContent(content: post['rendered']);
  }
}
