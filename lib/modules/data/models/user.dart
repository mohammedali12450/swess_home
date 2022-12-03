class User {
  int? id;

  String? firstName;

  String? lastName;

  String? authentication;

  String? email;

  String? birthdate;

  String? country;

  String? governorate;

  User(
      {this.firstName,
      this.lastName,
      this.authentication,
      this.id,
      this.email,
      this.country,
      this.governorate,
      this.birthdate});

  factory User.fromJson(json) {
    return User(
      id: json['id'] == null ? null : json['id'],
      firstName: json['first_name'] == null ? null : json['first_name'],
      lastName: json['last_name'] == null ? null : json['last_name'],
      authentication: json['authentication'] == null ? null : json['authentication'],
      email: json['email'] == null ? null : json['email'],
      country: json['country'] == null ? null : json['country'],
      governorate: json['governorate'] == null ? null : json['governorate'],
      birthdate: json['birthdate'] == null ? null : json['birthdate'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> map = {};
  //   map["first_name"] = firstName;
  //   map["last_name"] = lastName;
  //   map["authentication"] = authentication;
  //   map["email"] = email;
  //   map["dob"] = birthdate;
  //   map["location_id"] = governorate;
  //   map["country"] = country;
  //   return map;
  // }
}
