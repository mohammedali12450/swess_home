// To parse this JSON data, do
//
//     final userOtpModel = userOtpModelFromJson(jsonString);

import 'dart:convert';

UserOtpModel userOtpModelFromJson(String str) =>
    UserOtpModel.fromJson(json.decode(str));

String userOtpModelToJson(UserOtpModel data) => json.encode(data.toJson());

class UserOtpModel {
  UserOtpModel({
    this.data,
  });

  UserItem? data;

  factory UserOtpModel.fromJson(Map<String, dynamic> json) => UserOtpModel(
        data: json["data"] == null ? null : UserItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class UserItem {
  UserItem({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.roleId,
    this.authentication,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? role;
  int? roleId;
  String? authentication;

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        role: json["role"] == null ? null : json["role"],
        roleId: json["role_id"] == null ? null : json["role_id"],
        authentication:
            json["authentication"] == null ? null : json["authentication"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "role": role == null ? null : role,
        "role_id": roleId == null ? null : roleId,
        "authentication": authentication == null ? null : authentication,
      };
}
