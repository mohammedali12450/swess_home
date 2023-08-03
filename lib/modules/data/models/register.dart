class Register {
  String firstName;

  String lastName;

  String authentication;

  String? password;

  // String? email;

  //String birthdate;

  String? country;

  int? governorate;

  // double? latitude, longitude;

  Register(
      {required this.firstName,
      required this.lastName,
      required this.authentication,
      this.password,
      // this.email,
      //required this.birthdate,
      this.governorate,
      this.country,
      // this.latitude,
      // this.longitude
      });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["authentication"] = authentication;
    map["password"] = password;
    // map["email"] = email;
    //map["dob"] = birthdate;
    map["location_id"] = governorate;
    map["country"] = country;
    // map["latitude"] = latitude;
    // map["longitude"] = longitude;
    return map;
  }

  Map<String, dynamic> toJsonEdit() {
    Map<String, dynamic> map = {};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    // map["email"] = email;
    //map["dob"] = birthdate;
    map["location_id"] = governorate;
    map["_method"] = "PUT";
    return map;
  }
}
