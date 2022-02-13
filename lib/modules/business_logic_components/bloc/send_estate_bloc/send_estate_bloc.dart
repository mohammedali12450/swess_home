import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'send_estate_event.dart';
import 'send_estate_state.dart';

class SendEstateBloc extends Bloc<SendEstateEvent, SendEstateState> {
  EstateRepository estateRepository;

  SendEstateBloc({required this.estateRepository}) : super(SendEstateNone()) {
    on<SendEstateStarted>((event, emit) async {
      emit(SendEstateProgress());
      try {
        await estateRepository.sendEstate(event.estate, event.token,
            onSendProgress: event.onSendProgress);
        emit(SendEstateComplete());
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    });
  }
}
