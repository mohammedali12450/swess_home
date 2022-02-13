

import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelCubit extends Cubit<dynamic> {
  ChannelCubit(initialState) : super(initialState);
  void setState(dynamic data) => emit(data);
}
