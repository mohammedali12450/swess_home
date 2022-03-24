class Report {
  int id;

  String nameArabic;
  String nameEnglish ;

  String getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }


  Report({required this.id, required this.nameArabic , required this.nameEnglish});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(id: json["id"], nameArabic: json["name_ar"] , nameEnglish: json["name_en"]);
  }
}
