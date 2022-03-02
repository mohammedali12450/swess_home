

abstract class NotificationTypesState{}

class NotificationTypesFetchProgress extends NotificationTypesState {}
class NotificationTypesFetchError extends NotificationTypesState {
  String error ;

  NotificationTypesFetchError({required this.error});
}
class NotificationTypesFetchComplete extends NotificationTypesState {}
class NotificationTypesFetchNone extends NotificationTypesState {}