class Register {
  String firstName;

  String lastName;

  String authentication;

  String password;

  Register(
      {required this.firstName,
      required this.lastName,
      required this.authentication,
      required this.password});


  Map<String , dynamic> toJson(){
    Map<String , dynamic> map = {};
    map["first_name"] = firstName ;
    map["last_name"] = lastName ;
    map["authentication"] = authentication ;
    map["password"] = password ;
    return map ;
  }
}
