import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';
import 'package:swesshome/core/exceptions/general_exception.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import '../../../data/repositories/estate_repository.dart';
import 'office_details_event.dart';
import 'office_details_state.dart';

class GetOfficesBloc extends Bloc<GetOfficesEvents, GetOfficesStates> {
  EstateRepository estateRepository;

  GetOfficesBloc(this.estateRepository) : super(GetOfficesFetchNone()) {
    on<GetOfficesDetailsStarted>((event, emit) async {
      emit(GetOfficesFetchProgress());
      try {
        print("ghina12");
        EstateOffice results =
            await estateRepository.getOfficeDetails(event.officeId!);
        print("ghina13");
        emit(GetOfficesFetchComplete(results: results));

      } on ConnectionException catch (e) {
        emit(GetOfficesFetchError(errorMessage: e.errorMessage));
      } catch (e) {
        if (e is GeneralException) {
          emit(GetOfficesFetchError(errorMessage: e.errorMessage!));
        }
      }
    });
  }
}
