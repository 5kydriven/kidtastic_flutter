import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterState initialState;
  RegisterBloc({required this.initialState}) : super(initialState);
}
