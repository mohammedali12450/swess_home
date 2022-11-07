import 'dart:convert';

OtpRequestValueModel otpRequestValueFromJson(String str) =>
    OtpRequestValueModel.fromJson(json.decode(str));

String otpRequestValueToJson(OtpRequestValueModel data) =>
    json.encode(data.toJson());

class OtpRequestValueModel {
  OtpRequestValueModel({
    this.textValue,
    this.requestedTime,
  });

  String? textValue;
  DateTime? requestedTime;

  factory OtpRequestValueModel.fromJson(Map<String, dynamic> json) =>
      OtpRequestValueModel(
        textValue: json["textValue"] == null ? null : json["textValue"],
        requestedTime: json["requestedTime"] == null
            ? null
            : DateTime.parse(json["requestedTime"]),
      );

  Map<String, dynamic> toJson() => {
        "textValue": textValue == null ? null : textValue,
        "requestedTime":
            requestedTime == null ? null : requestedTime!.toIso8601String(),
      };
}
