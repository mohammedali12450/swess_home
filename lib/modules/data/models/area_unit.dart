class AreaUnit {
  int id;

  String nameArabic;
  String nameEnglish;

  getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }

  AreaUnit({required this.id, required this.nameArabic , required this.nameEnglish});

  factory AreaUnit.copy(AreaUnit areaUnit) {
    return AreaUnit(id: areaUnit.id, nameArabic: areaUnit.nameArabic , nameEnglish: areaUnit.nameEnglish);
  }

  factory AreaUnit.init() {
    return AreaUnit(id: -1, nameArabic: "default" , nameEnglish: "default");
  }

  factory AreaUnit.fromJson(json) {
    return AreaUnit(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json["name_en"]
    );
  }
}
