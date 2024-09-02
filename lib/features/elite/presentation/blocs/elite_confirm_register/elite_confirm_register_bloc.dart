import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/elite_register_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_confirm_register_event.dart';
part 'elite_confirm_register_state.dart';

class EliteConfirmRegisterBloc
    extends Bloc<EliteConfirmRegisterEvent, EliteConfirmRegisterState> {
  final EliteConfirmRegisterUc eliteConfirmRegisterUc;
  EliteConfirmRegisterBloc({required this.eliteConfirmRegisterUc})
      : super(EliteConfirmRegisterInitial()) {
    on<EliteConfirmRegisterEvents>((event, emit) async {
      emit(EliteConfirmRegisterLoadingState());
      final result = await eliteConfirmRegisterUc(event.customerId);
      result.fold(
        (l) => emit(EliteConfirmRegisterFailureState(l, l.code, l.messages)),
        (r) => emit(EliteConfirmRegisterSuccessState(r)),
      );
    });
  }
}
