import 'package:bloc/bloc.dart';
import 'package:swesshome/core/storage/shared_preferences/notifications_shared_preferences.dart';

class NotificationsCubit extends Cubit<int> {
  NotificationsCubit(int initialNotificationsCount)
      : super(initialNotificationsCount);

  void checkNewNotifications() {
    int newNotificationsCount =
        NotificationsSharedPreferences.getNotificationsCount();
    emit(newNotificationsCount);
    print("notification count emitted!");
  }
}
