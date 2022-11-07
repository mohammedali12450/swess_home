import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/rating_bloc/rating_state.dart';
import 'package:swesshome/modules/data/repositories/rating_repository%7B.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingRepository ratingRepository;

  RatingBloc(this.ratingRepository) : super(RatingNone()) {
    on<RatingStarted>(
      (event, emit) async {
        emit(RatingProgress());
        try {
          await ratingRepository.sendRate(event.token, event.notes, event.rate);
          emit(RatingComplete());
        } on ConnectionException catch (e) {
          emit(RatingError(error: e.errorMessage , isConnectionError: true));
        } catch (e) {
          if (e is GeneralException) {
            emit(RatingError(error: e.errorMessage!));
          }
        }
      },
    );
  }
}
