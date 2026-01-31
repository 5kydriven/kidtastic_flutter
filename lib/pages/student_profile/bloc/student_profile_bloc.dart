import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/student_profile_event.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/state/student_profile_state.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvent, StudentProfileState> {
  StudentProfileBloc({
    required StudentProfileState initialState,
  }) : super(initialState);
}
