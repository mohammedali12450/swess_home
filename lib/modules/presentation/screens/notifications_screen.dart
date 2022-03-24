import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/storage/shared_preferences/notifications_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/notifications_bloc/notifications_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/business_logic_components/cubits/notifications_cubit.dart';
import 'package:swesshome/modules/data/models/my_notification.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/widgets/fetch_result.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/notification_card.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/notifications_shimmer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
          automaticallyImplyLeading: false,
          toolbarHeight: Res.height(75),
          backgroundColor: AppColors.secondaryColor,
          title: SizedBox(
            width: screenWidth,
            child: ResText(
              'الإشعارات',
              textStyle: textStyling(S.s18, W.w5, C.c1),
              textAlign: TextAlign.right,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_outlined,
                color: AppColors.baseColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: (BlocProvider.of<UserLoginBloc>(context).user != null)
            ? RefreshIndicator(
                color: AppColors.secondaryColor,
                onRefresh: () async {
                  _onRefresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight - Res.height(75),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: Res.width(12),
                      vertical: Res.height(8),
                    ),
                    child: BlocConsumer<NotificationsBloc, NotificationsState>(
                        listener: (_, notificationsState) {
                      if (notificationsState is NotificationsFetchError) {
                        showWonderfulAlertDialog(context, "خطأ", notificationsState.error);
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
                                color: AppColors.secondaryColor.withOpacity(0.12),
                                size: screenWidth / 2,
                              ),
                              kHe24,
                              ResText(
                                "ليس لديك إشعارات",
                                textStyle: textStyling(S.s24, W.w5, C.c2).copyWith(
                                  color: AppColors.secondaryColor.withOpacity(0.32),
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
                              onTap: (){

                              },
                            );
                          },
                        );
                      }
                      return const FetchResult(content: "حدث خطأ أثناء تنفيذ العملية");
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
                      color: AppColors.secondaryColor.withOpacity(0.12),
                      size: screenWidth / 2,
                    ),
                    kHe24,
                    ResText(
                      "قم بتسجيل الدخول لتصلك الإشعارات",
                      textStyle: textStyling(S.s24, W.w5, C.c2).copyWith(
                        color: AppColors.secondaryColor.withOpacity(0.32),
                      ),
                      maxLines: 3,
                    ),
                    kHe32,
                    MyButton(
                      width: Res.width(250),
                      child: ResText(
                        "تسجيل الدخول",
                        textStyle: textStyling(S.s16, W.w5, C.wh),
                      ),
                      color: AppColors.secondaryColor,
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
