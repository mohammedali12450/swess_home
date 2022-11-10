class Register {
  String firstName;

  String lastName;

  String authentication;

  String password;

  String? email;

  DateTime birthdate;

  String? country;

  double? latitude, longitude;

  Register(
      {required this.firstName,
      required this.lastName,
      required this.authentication,
      required this.password,
      this.email,
      required this.birthdate,
      this.country,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["authentication"] = authentication;
    map["password"] = password;
    return map;
  }
}
