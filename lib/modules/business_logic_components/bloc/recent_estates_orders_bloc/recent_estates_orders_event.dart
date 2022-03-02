abstract class RecentEstatesOrdersEvent {}

class RecentEstatesOrdersFetchStarted extends RecentEstatesOrdersEvent {
  final String token ;

  RecentEstatesOrdersFetchStarted({required this.token});
}
