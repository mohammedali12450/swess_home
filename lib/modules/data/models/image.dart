class Image {
  String url;

  String type;

  Image({required this.url, required this.type});

  factory Image.fromJson(json) {
    return Image(
      url: json["url"],
      type: json["type"],
    );
  }
}
