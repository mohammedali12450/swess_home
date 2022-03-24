class InteriorStatus {
  final int id;

  final String nameArabic;
  final String nameEnglish;


  String getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }
  InteriorStatus({required this.id, required this.nameArabic, required this.nameEnglish});

  factory InteriorStatus.copy(InteriorStatus interiorStatus) {
    return InteriorStatus(
      id: interiorStatus.id,
      nameArabic: interiorStatus.nameArabic,
      nameEnglish: interiorStatus.nameEnglish,
    );
  }

  factory InteriorStatus.fromJson(json) {
    return InteriorStatus(id: json['id'], nameArabic: json['name_ar'] , nameEnglish: json["name_en"]);
  }
}
