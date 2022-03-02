import 'package:swesshome/modules/data/models/my_notification.dart';


abstract class NotificationsState {}

class NotificationsFetchProgress extends NotificationsState {}

class NotificationsFetchError extends NotificationsState {
  String error;

  NotificationsFetchError({required this.error});
}

class NotificationsFetchComplete extends NotificationsState {
  List<MyNotification> notifications ;

  NotificationsFetchComplete({required this.notifications});
}

class NotificationsFetchNone extends NotificationsState {}
