import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginState initialState;
  LoginBloc({required this.initialState}) : super(initialState);
}
