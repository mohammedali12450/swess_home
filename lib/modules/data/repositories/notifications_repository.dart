import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/my_notification.dart';
import 'package:swesshome/modules/data/models/notification_type.dart';
import 'package:swesshome/modules/data/providers/notifications_provider.dart';

class NotificationRepository {
  final NotificationsProvider _notificationsProvider = NotificationsProvider();

  Future getNotificationTypes() async {
    Response response = await _notificationsProvider.getNotificationTypes();

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث أثناء الاتصال بالسيرفر");
    }

    var jsonNotificationTypes = jsonDecode(response.toString())["data"] as List;

    List<NotificationType> notificationTypes =
        jsonNotificationTypes.map((e) => NotificationType.fromJson(e)).toList();

    return notificationTypes;
  }

  Future getNotifications(String token) async {
    Response response;

    try {
      response = await _notificationsProvider.getNotifications(token);
    } catch (e) {
      rethrow;
    }

    if (response.statusCode != 200) {
      throw GeneralException(errorMessage: "حدث أثناء الاتصال بالسيرفر");
    }

    var jsonNotifications = jsonDecode(response.toString())["data"] as List;

    List<MyNotification> notifications =
        jsonNotifications.map((e) => MyNotification.fromJson(e)).toList();

    return notifications;
  }
}
