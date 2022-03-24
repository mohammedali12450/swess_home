class PeriodType {
  int id;

  String nameArabic;
  String nameEnglish;

  getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }

  PeriodType({required this.id, required this.nameArabic , required this.nameEnglish});

  factory PeriodType.copy(PeriodType periodType) {
    return PeriodType(id: periodType.id, nameArabic: periodType.nameArabic , nameEnglish: periodType.nameEnglish);
  }

  factory PeriodType.fromJson(json) {
    return PeriodType(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json["name_en"]
    );
  }
}
