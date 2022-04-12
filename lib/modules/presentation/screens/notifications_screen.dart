import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/storage/shared_preferences/notifications_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/notifications_cubit.dart';
import 'package:swesshome/modules/data/models/my_notification.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/notification_card.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  static const String id = "NotificationScreen";

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsBloc notificationsBloc;
  late String token;
  late int newNotificationsCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (BlocProvider.of<UserLoginBloc>(context).user != null) {
      notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
      token = BlocProvider.of<UserLoginBloc>(context).user!.token!;
      notificationsBloc.add(
        NotificationsFetchStarted(token: token),
      );
      newNotificationsCount = NotificationsSharedPreferences.getNotificationsCount();
      clearNotificationsCount();
    }
  }

  Future clearNotificationsCount() async {
    await NotificationsSharedPreferences.setNotificationsCount(0);
    BlocProvider.of<NotificationsCubit>(context).checkNewNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.notifications,
          ),
        ),
        body: (BlocProvider.of<UserLoginBloc>(context).user != null)
            ? RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: () async {
                  _onRefresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: 1.sw,
                    height: 1.sh - 75.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: BlocConsumer<NotificationsBloc, NotificationsState>(
                        listener: (_, notificationsState) {
                      if (notificationsState is NotificationsFetchError) {
                        showWonderfulAlertDialog(
                            context, AppLocalizations.of(context)!.error, notificationsState.error);
                      }
                    }, builder: (context, notificationsState) {
                      if (notificationsState is NotificationsFetchProgress) {
                        return const NotificationsShimmer();
                      }
                      if (notificationsState is NotificationsFetchComplete) {
                        List<MyNotification> notifications = notificationsState.notifications;

                        if (notifications.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                size: 0.5.sw,
                              ),
                              kHe24,
                              Text(
                                AppLocalizations.of(context)!.you_have_not_notifications,
                                style: Theme.of(context).textTheme.headline5!.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary.withOpacity(0.32),
                                    ),
                              ),
                            ],
                          );
                        }

                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: notifications.length,
                          itemBuilder: (_, index) {
                            MyNotification notification = notifications.elementAt(index);
                            return NotificationCard(
                              title: notification.title,
                              body: notification.body,
                              date: DateHelper.getDateByFormat(
                                  DateTime.parse(notification.date), "yyyy/MM/dd"),
                              isNew: index < newNotificationsCount,
                              onTap: () {},
                            );
                          },
                        );
                      }
                      return  FetchResult(
                          content: AppLocalizations.of(context)!
                              .error_happened_when_executing_operation);
                    }),
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                padding: kMediumSymWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      size: 0.5.sw,
                    ),
                    kHe24,
                    Text(
                      AppLocalizations.of(context)!.sign_in_for_notifications,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.32),
                      ),
                      maxLines: 3,
                    ),
                    kHe32,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(240.w , 64.h)
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.sign_in,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthenticationScreen(
                              popAfterFinish: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future _onRefresh() async {
    notificationsBloc.add(
      NotificationsFetchStarted(token: token),
    );
  }
}
