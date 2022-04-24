class MyImage {
  String url;

  String type;

  int id ;

  MyImage({required this.url, required this.type , required this.id});

  factory MyImage.fromJson(json) {
    return MyImage(
      url: json["url"] ?? "404",
      type: json["type"] ?? "404",
      id : json["id"] ?? 1,
    );
  }
}
