class EstateType {
  final int id;

  final String nameArabic;
  final String nameEnglish;


  getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }

  factory EstateType.copy(EstateType estateType) {
    return EstateType(id: estateType.id, nameArabic: estateType.nameArabic ,nameEnglish: estateType.nameEnglish );
  }

  factory EstateType.init(){
    return EstateType(id: -1, nameArabic: "default" , nameEnglish: "default") ;
  }

  EstateType({required this.id, required this.nameArabic ,required this.nameEnglish});

  factory EstateType.fromJson(json) {
    return EstateType(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json["name_en"]
    );
  }
}
