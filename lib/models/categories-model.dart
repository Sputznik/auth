class Categories {
  final int totalResponses;
  final List<Topic> topics;

  Categories({this.totalResponses, this.topics});

  factory Categories.fromJson(Map<String, dynamic> parsedJson) {
    return Categories(
        totalResponses: parsedJson['totalResponses'],
        topics: termsList(parsedJson['topics']));
  }

  static List<Topic> termsList(parsedTerms) {
    var list = parsedTerms as List;
    List<Topic> termsList = list.map((i) => Topic.fromJson(i)).toList();
    return termsList;
  }
}

class Topic {
  final int id;
  final String slug;
  final String name;

  Topic({this.id, this.slug, this.name});

  factory Topic.fromJson(Map<String, dynamic> parsedJson) {
    return Topic(
        id: parsedJson['term_id'],
        slug: parsedJson['slug'],
        name: parsedJson['name']);
  }
}
