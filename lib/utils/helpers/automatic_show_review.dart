import 'dart:async';

import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/utils/helpers/app_dialog.dart';

Timer? timer;

Future<void> automaticShowReview() async {
  const Duration duration = Duration(days: 10);
  final dateShowReview = UserSharedPreferences.getDateShowReview();

  if (dateShowReview == null) {
    await UserSharedPreferences.setDateShowReview(
      DateTime.now().add(duration).toString(),
    );
  }

  const Duration durationJump = Duration(seconds: 5);

  if (timer != null) {
    timer?.cancel();
  }

  timer = Timer.periodic(
    durationJump,
    (Timer timer) async {
      DateTime dateCashe = DateTime.tryParse(
            UserSharedPreferences.getDateShowReview() ?? '',
          ) ??
          DateTime.now();

      if (dateCashe.isBefore(DateTime.now())) {
        Future.delayed(Duration.zero).then((_) {
          if (!AppDialog.isDialogReviewShow) {
            AppDialog.reviewDialog(context: navigatorKey.currentState!.context);
          }
        });
        await UserSharedPreferences.setDateShowReview(
          DateTime.now().add(duration).toString(),
        );
      }
    },
  );
}
