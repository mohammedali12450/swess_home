import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/notification_type.dart';
import 'package:swesshome/modules/data/repositories/notifications_repository.dart';

import 'notification_types_event.dart';
import 'notification_types_state.dart';

class NotificationTypesBloc
    extends Bloc<NotificationTypesEvent, NotificationTypesState> {
  NotificationRepository notificationRepository;

  List<NotificationType>? notificationTypes;

  NotificationTypesBloc(this.notificationRepository)
      : super(NotificationTypesFetchNone()) {
    on<NotificationTypesFetchStarted>((event, emit) async {
      try {
        notificationTypes = await notificationRepository.getNotificationTypes();
        emit(NotificationTypesFetchComplete()) ;
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(NotificationTypesFetchError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
  }
}
