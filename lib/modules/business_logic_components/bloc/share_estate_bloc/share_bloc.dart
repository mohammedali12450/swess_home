import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/business_logic_components/bloc/share_estate_bloc/share_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/share_estate_bloc/share_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/visit_estate_bloc/dart/visit_state.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  EstateRepository estateRepository;

  ShareBloc(this.estateRepository) : super(ShareNone()) {
    on<ShareStarted>((event, emit) async {
      emit(ShareProgress());
      try {
        await estateRepository.shareEstateCount(event.token, event.estateId);
        emit(ShareComplete());
      } catch (e, stack) {
        if (e is GeneralException) {
          emit(ShareError(error: e.errorMessage!));
        }
        print(e);
        print(stack);
      }
    });
  }
}
