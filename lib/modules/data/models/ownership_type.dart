class OwnershipType {
  int id;

  String nameArabic;
  String nameEnglish;


  String getName(bool isArabic){
    return isArabic ? nameArabic : nameEnglish ;
  }
  OwnershipType({required this.id, required this.nameArabic, required this.nameEnglish});

  factory OwnershipType.copy(OwnershipType ownershipType) {
    return OwnershipType(
        id: ownershipType.id,
        nameArabic: ownershipType.nameArabic,
        nameEnglish: ownershipType.nameEnglish);
  }

  factory OwnershipType.fromJson(json) {
    return OwnershipType(
      id: json['id'],
      nameArabic: json['name_ar'],
      nameEnglish: json["name_en"] ,
    );
  }
}
