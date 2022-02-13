import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_event.dart';
import 'package:swesshome/modules/data/models/user.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'user_data_fetch_state.dart';

class UserDataFetchBloc extends Bloc<UserDataFetchEvent, UserDataFetchState> {
  UserAuthenticationRepository userAuthenticationRepository;

  UserDataFetchBloc({required this.userAuthenticationRepository})
      : super(UserDataFetchNone()) {
    on<UserDataFetchStarted>((event, emit) async {
      emit(UserDataFetchProgress());
      try {
        User user =
            await userAuthenticationRepository.loginByToken(event.token);
        user.token = event.token ;
        emit(UserDataFetchComplete(user: user));
      } catch (e, stack) {
        emit(UserDataFetchError());
        print(e);
        print(stack);
      }
    });
  }
}
