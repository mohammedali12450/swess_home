
import 'notification_type.dart';

class MyNotification {
  int id;

  NotificationType notificationType;

  String title;

  String body;

  String date ;

  int? estateId;

  MyNotification(
      {required this.id,
      required this.notificationType,
      required this.title,
      required this.body,
        required this.date ,
      this.estateId});

  factory MyNotification.fromJson(json) {
    return MyNotification(
      id: json["id"],
      notificationType: NotificationType.fromJson(json["notification_type"]),
      title: json["title"],
      body: json["body"],
      date : json["created_at"] ,
    );
  }
}
