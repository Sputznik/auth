class WordpressUser{

  int id;
  String name;
  //String url;
  //String description;
  String authKey;

  Map avatar_urls;

  WordpressUser(Map data){
    print(data);
    this.id = data.containsKey('id') ? data['id'] : 0;
    this.name = data.containsKey('name') ? data['name'] : "";
    //this.url = data.containsKey('url') ? data['url'] : "";
    //this.description = data.containsKey('description') ? data['description'] : "";
    this.authKey = data.containsKey('authKey') ? data['authKey'] : null;
    this.avatar_urls = data.containsKey('avatar_urls') ? data['avatar_urls'] : {};
  }


  bool isValidUser() => (this.id != null && this.id > 0) ? true : false;

  Map toJson(){
    return {
      'id' : this.id,
      'name'  : this.name,
      'avatar_urls' : this.avatar_urls,
      'authKey' : this.authKey,
    };
  }

  String toString() => toJson().toString();

}