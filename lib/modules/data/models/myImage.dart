class MyImage {
  String url;

  String type;

  int id ;

  MyImage({required this.url, required this.type , required this.id});

  factory MyImage.fromJson(json) {
    return MyImage(
      url: json["url"],
      type: json["type"],
      id : json["id"] ,
    );
  }
}
