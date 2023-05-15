import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/main.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/review_bloc/review_state.dart';
import 'package:swesshome/modules/data/models/review.dart';
import 'package:swesshome/modules/data/repositories/rating_repository.dart';
import 'package:swesshome/utils/helpers/app_flushbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final RatingRepository ratingRepository;
  ReviewBloc({required this.ratingRepository}) : super(const ReviewInit()) {
    on<ReviewPostEvent>((event, emit) async {
      emit(const ReviewLoading());

      try {
        final response = await ratingRepository.sendRate(
          event.token,
          event.notes,
          event.rate.toString(),
        );

        final review = Review.fromJson(response.data);

        emit(ReviewData(review: review));
      } on ConnectionException catch (e) {
        emit(ReivewError(message: e.errorMessage));
      } catch (e) {
        if (e is GeneralException) {
          emit(ReivewError(message: e.errorMessage ?? ""));
        }
        emit(
          ReivewError(
            message: AppLocalizations.of(navigatorKey.currentState!.context)!
                .anErrorOccurred,
          ),
        );
      }
    });
  }

  final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  final TextEditingController notesController = TextEditingController();
  final ValueNotifier<bool> isInputVaild = ValueNotifier(true);

  double rating = 1.0;
  bool get isRatingGood => rating > 3.0;

  String? notesValidator(val) {
    if (isRatingGood) return null;

    if (val != null && val.isEmpty) {
      return AppLocalizations.of(navigatorKey.currentState!.context)!
          .youMustBeAddRating;
    }

    return null;
  }

  void onUpdateRating(double rating) {
    this.rating = rating;
  }

  Future<void> cancelReview() async {
    Navigator.of(navigatorKey.currentState!.context).pop();
  }

  Future<void> sendReview() async {
    final isVaild = formStateKey.currentState?.validate() ?? false;
    isInputVaild.value = isVaild;
    if (!isVaild) return;
    String? token = UserSharedPreferences.getAccessToken();
    add(
      ReviewPostEvent(
        token: token ?? "",
        rate: rating,
        notes: notesController.text,
      ),
    );
  }

  Future<void> listenerReviewPost(_, state) async {
    BuildContext context = navigatorKey.currentState!.context;
    if (state is ReviewLoading) {
      context.loaderOverlay.show();
    }
    if (state is! ReviewLoading) {
      context.loaderOverlay.hide();
    }
    if (state is ReivewError) {
      AppFlushbar.show(
        message: state.message,
        isTop: false,
      );
    }
    if (state is ReviewData) {
      Navigator.of(context).pop();
      AppFlushbar.show(
        message: AppLocalizations.of(context)!.thankYouAddingReview,
        icon: Icons.done_all_rounded,
      );
    }
  }

  @override
  Future<void> close() {
    notesController.dispose();
    isInputVaild.dispose();
    return super.close();
  }
}
