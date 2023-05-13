import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_bloc.dart';
import 'package:swesshome/modules/data/repositories/rating_repository.dart';
import 'package:swesshome/modules/presentation/widgets/review/review_dialog.dart';

class AppDialog {
  static bool isDialogReviewShow = false;
  static Future reviewDialog({required BuildContext context}) async {
    isDialogReviewShow = true;
    final dialog = await showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, widget) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.075),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.5,
              end: 1.0,
            ).animate(anim1),
            child: widget,
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return BlocProvider<ReviewBloc>(
          create: (context) => ReviewBloc(
            ratingRepository: RatingRepository(),
          ),
          child: const RatingDialog(),
        );
      },
    );
    isDialogReviewShow = false;

    return dialog;
  }
}
