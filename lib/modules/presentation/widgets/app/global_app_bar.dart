import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/assets_paths.dart';
import '../../../../constants/colors.dart';
import '../../../../core/storage/shared_preferences/user_shared_preferences.dart';
import '../../../business_logic_components/cubits/notifications_cubit.dart';
import '../../screens/authentication_screen.dart';
import '../../screens/notifications_screen.dart';
import '../icone_badge.dart';
import '../wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalAppbarWidget extends StatelessWidget {
  const GlobalAppbarWidget({
    super.key,
    required this.isDark, required this.title,
  });

  final bool isDark;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme:
      IconThemeData(color: isDark ? Colors.white : AppColors.black),
      centerTitle: true,
      backgroundColor:
      isDark ? const Color(0xff26282B) : AppColors.white,
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xff130D0D),
        ),
      ),
      actions: [
        InkWell(
          child: BlocBuilder<NotificationsCubit, int>(
            builder: (_, notificationsCount) {
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 12.w),
                child: IconBadge(
                  icon: SvgPicture.asset(
                    bellPath,
                    width: 25,
                    height: 25,
                    color: isDark ? Colors.white : AppColors.black,
                  ),
                  itemCount: 2,
                  right: 0,
                  top: 10.h,
                  badgeColor: Color(0xff2A84D1),
                  hideZero: false,
                ),
              );
            },
          ),
          onTap: () async {
            if (UserSharedPreferences.getAccessToken() == null) {
              await showWonderfulAlertDialog(
                  context,
                  AppLocalizations.of(context)!.confirmation,
                  AppLocalizations.of(context)!
                      .this_features_require_login,
                  removeDefaultButton: true,
                  dialogButtons: [
                    ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.sign_in,
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(
                            context, AuthenticationScreen.id);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  width: 400.w);
              return;
            }
            Navigator.pushNamed(context, NotificationScreen.id);
          },
        ),
      ],
    );
  }
}