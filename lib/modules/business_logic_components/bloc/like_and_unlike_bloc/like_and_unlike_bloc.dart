import 'package:bloc/bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'like_and_unlike_event.dart';
import 'like_and_unlike_state.dart';

class LikeAndUnlikeBloc extends Bloc<LikeAndUnlikeEvent, LikeAndUnlikeState> {
  EstateRepository estateRepository;

  LikeAndUnlikeBloc(LikeAndUnlikeState initialState, this.estateRepository) : super(initialState) {
    on<LikeStarted>((event, emit) async {
      emit(LikeAndUnlikeProgress());
      try {
        await estateRepository.like(event.token, event.likedObjectId, event.likeType);
        emit(Liked());
      } on ConnectionException catch (e) {
        emit(LikeAndUnlikeError(error: e.errorMessage , isConnectionError: true));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(LikeAndUnlikeError(error: e.errorMessage));
        }
        print(e);
        print(stack);
      }
    });

    on<UnlikeStarted>((event, emit) async {
      emit(LikeAndUnlikeProgress());
      try {
        await estateRepository.unlikeEstate(event.token, event.unlikedObjectId, event.likeType);
        emit(Unliked());
      } on ConnectionException catch (e) {
        emit(LikeAndUnlikeError(error: e.errorMessage));
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(LikeAndUnlikeError(error: e.errorMessage));
        }
        print(e);
        print(stack);
      }
    });

    on<ReInitializeLikeState>((event, emit) {
      if (event.isLike) {
        emit(Liked());
      } else {
        emit(Unliked());
      }
    });




  }
}
