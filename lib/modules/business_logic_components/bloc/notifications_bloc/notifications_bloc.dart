import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/my_notification.dart';
import 'package:swesshome/modules/data/repositories/notifications_repository.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationRepository notificationRepository;

  NotificationsBloc(this.notificationRepository) : super(NotificationsFetchNone()) {
    on<NotificationsFetchStarted>((event, emit) async {
      emit(NotificationsFetchProgress());

      try {
        List<MyNotification> notifications =
            await notificationRepository.getNotifications(event.token);
        emit(NotificationsFetchComplete(notifications: notifications.reversed.toList()));
      } on ConnectionException catch (e) {
        emit(NotificationsFetchError(error: e.errorMessage , isConnectionError: true));
      } catch (e) {
        if (e is GeneralException) {
          emit(NotificationsFetchError(error: e.errorMessage));
        }
      }
    });
  }
}
