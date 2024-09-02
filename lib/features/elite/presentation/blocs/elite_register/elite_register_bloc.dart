import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/elite_register_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_register_event.dart';
part 'elite_register_state.dart';

class EliteRegisterBloc extends Bloc<EliteRegisterEvent, EliteRegisterState> {
  final EliteRegisterUc eliteRegisterUc;
  EliteRegisterBloc({required this.eliteRegisterUc})
      : super(EliteRegisterInitial()) {
    on<EliteRegisterEvents>((event, emit) async {
      emit(EliteRegisterLoadingState());
      final result = await eliteRegisterUc(EliteRegisterParams(
        customerId: event.customerId,
        packageId: event.packageId,
        paymentMethodId: event.paymentMethodId,
        voucherId: event.voucherId,
        autoRenewalPaymentMethod: event.autoRenewalPaymentMethod,
        referalCode: event.referalCode,
      ));
      result.fold(
        (l) => emit(EliteRegisterFailureState(l, l.code, l.messages)),
        (r) => emit(EliteRegisterSuccessState(r)),
      );
    });
  }
}
