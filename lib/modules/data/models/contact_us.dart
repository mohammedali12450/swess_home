
class ContactUs {
  ContactUsData? contactUsData;
  String? message;
  int? status;

  ContactUs({
    this.contactUsData,
    this.message,
    this.status,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
    contactUsData: ContactUsData.fromJson(json["data"]),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": contactUsData!.toJson(),
    "message": message,
    "status": status,
  };
}

class ContactUsData {
  int? id;
  String? senderEmail;
  String? subject;
  String? message;
  String? status;
  // DateTime createdAt;

  ContactUsData({
    required this.id,
    required this.senderEmail,
    required this.subject,
    required this.message,
    required this.status,
    // required this.createdAt,
  });

  factory ContactUsData.fromJson(Map<String, dynamic> json) => ContactUsData(
    id: json["id"] == null ? null : json["id"],
    senderEmail: json["sender_email"] == null ? null : json["sender_email"],
    subject: json["subject"] == null ? null : json["subject"],
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
    // createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_email": senderEmail,
    "subject": subject,
    "message": message,
    "status": status,
    // "created_at": createdAt.toIso8601String(),
  };
}
