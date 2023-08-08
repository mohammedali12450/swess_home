import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_state.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/review/add_rating.dart';
import 'package:swesshome/modules/presentation/widgets/review/notes_review_field.dart';
import 'package:swesshome/modules/presentation/widgets/review/review_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../business_logic_components/bloc/review_bloc/review_event.dart';
import '../../../data/providers/locale_provider.dart';
import '../wonderful_alert_dialog.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return RatingDialogState();
  }
}

class RatingDialogState extends State<RatingDialog> {
  late SharedPreferences _prefs;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimerActive = false;
  @override
  void initState() {
    _loadTimer();
    super.initState();
  }
  Future<void> _loadTimer() async {
    _prefs = await SharedPreferences.getInstance();
    final lastResetTime = _prefs.getInt('rate_app') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedSeconds = (now - lastResetTime) ~/ 1000;
    if (elapsedSeconds > 600) {
      _remainingSeconds = 0;
    } else {
      _remainingSeconds = 600 - elapsedSeconds;
      _startTimer();
    }
  }
  Future<void> _savePreferences() async {
    await _prefs.setInt(
        'rate_app', DateTime.now().millisecondsSinceEpoch);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
        }
      });
    });
    _isTimerActive = true;
  }

  void _stopTimer() {
    _timer?.cancel();
    _isTimerActive = false;
  }
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    bool isLandscape = mediaQueryData.orientation == Orientation.landscape;
    final ReviewBloc reviewBloc = context.read<ReviewBloc>();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 15.w : 30.w,
          ),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
          ),
          content: BlocListener<ReviewBloc, ReviewState>(
            listener: reviewBloc.listenerReviewPost,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: ValueListenableBuilder<bool>(
                  valueListenable: reviewBloc.isInputVaild,
                  builder: (_, value, child) => AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: 0.8.sw,

                      padding: EdgeInsets.symmetric(
                        horizontal: 0.05.sw,
                      ),
                      color: isDark? AppColors.secondaryDark : Colors.white,
                      child: child!,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 0.018.sh,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addReview,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: isDark? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.0145.sh),
                        AddRating(
                          initialRating: reviewBloc.rating,
                          onRatingUpdate: reviewBloc.onUpdateRating,
                        ),
                        NotesReviewField(
                          formStateKey: reviewBloc.formStateKey,
                          controller: reviewBloc.notesController,
                          validator: reviewBloc.notesValidator,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ReviewButton(
                              onPresses: reviewBloc.cancelReview,
                              text: AppLocalizations.of(context)!.cancel,
                            ),
                            ReviewButton(
                              onPresses: () async {
                                if (_remainingSeconds > 0){
                                  print("remaining seconds is $_remainingSeconds");
                                  reviewBloc.add(ReviewPostBeforeTimer());
                                  showWonderfulAlertDialog(
                                    context,
                                    AppLocalizations.of(context)!.error,
                                    Provider.of<LocaleProvider>(context,listen: false).getLocale().languageCode == "ar"?
                                    "لقد تجاوزت الحد المسموح به لتقييم التطبيق" :
                                    "You have Reached the limit to rate the app",
                                  );
                                }
                                else
                                {
                                  reviewBloc.sendReview();
                                  _isTimerActive ? null : await _savePreferences();
                                  setState(() {
                                    _remainingSeconds = 900;
                                    _startTimer();
                                  });
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              text: AppLocalizations.of(context)!.send,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}