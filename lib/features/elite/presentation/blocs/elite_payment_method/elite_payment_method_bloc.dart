import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/elite_payment_method_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_payment_method_event.dart';
part 'elite_payment_method_state.dart';

class ElitePaymentMethodBloc
    extends Bloc<ElitePaymentMethodEvent, ElitePaymentMethodState> {
  final ElitePaymentMethodUc elitePaymentMethodUc;
  ElitePaymentMethodBloc({required this.elitePaymentMethodUc})
      : super(ElitePaymentMethodInitial()) {
    on<GetElitePaymentMethodEvent>((event, emit) async {
      emit(ElitePaymentMethodLoadingState());
      final result = await elitePaymentMethodUc();
      result.fold(
        (l) => emit(ElitePaymentMethodFailureState(l, l.code, l.messages)),
        (r) => emit(ElitePaymentMethodSuccessState(r)),
      );
    });
  }
}
