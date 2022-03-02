

abstract class NotificationsEvent{}
class NotificationsFetchStarted extends NotificationsEvent{
  String token ;

  NotificationsFetchStarted({required this.token});
}