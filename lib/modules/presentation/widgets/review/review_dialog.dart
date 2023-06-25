import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_state.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/review/add_rating.dart';
import 'package:swesshome/modules/presentation/widgets/review/notes_review_field.dart';
import 'package:swesshome/modules/presentation/widgets/review/review_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({super.key});

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
                      height: value ? 0.25.sh : 0.3.sh,
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
                              onPresses: reviewBloc.sendReview,
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
