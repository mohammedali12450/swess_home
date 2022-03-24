class EstateOfferType {
  final int id;

  final String nameArabic;
  final String nameEnglish;


  getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }
  EstateOfferType({required this.id, required this.nameArabic, required this.nameEnglish});

  factory EstateOfferType.copy(EstateOfferType estateOfferType) {
    return EstateOfferType(
        id: estateOfferType.id,
        nameArabic: estateOfferType.nameArabic,
        nameEnglish: estateOfferType.nameEnglish);
  }

  factory EstateOfferType.init() {
    return EstateOfferType(id: -1, nameArabic: "default" , nameEnglish: "default");
  }

  factory EstateOfferType.fromJson(json) {
    return EstateOfferType(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json["name_en"] ,
    );
  }
}
