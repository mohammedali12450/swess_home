class User {
  int id;

  String userName;

  String lastName;

  String authentication;

  String? password;

  String? token;

  User({
    required this.userName,
    required this.lastName,
    required this.authentication,
    required this.id,
    this.password,
    this.token,
  });


  factory User.fromJson(json) {
    return User(
      userName: json['first_name'],
      lastName: json['last_name'],
      authentication: json['authentication'],
      id: json['id'],
      token: json['token'],
    );
  }
}
