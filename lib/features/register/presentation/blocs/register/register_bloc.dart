import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/register_entity.dart';
import '../../../domain/usecases/register_uc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUc registerUc;

  RegisterBloc({required this.registerUc}) : super(RegisterInitial()) {
    on<RegisterPressed>((event, emit) async {
      emit(RegisterLoading());
      final result = await registerUc.call(RegisterParams(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (l) => emit(RegisterFailure(l, l.code, l.messages)),
        (r) => emit(RegisterSuccess(r)),
      );
    });
  }
}
