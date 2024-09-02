import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/elite_referal_validation_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_referal_validation_event.dart';
part 'elite_referal_validation_state.dart';

class EliteReferalValidationBloc
    extends Bloc<EliteReferalValidationEvent, EliteReferalValidationState> {
  final EliteReferalValidationUc eliteReferalValidationUc;

  EliteReferalValidationBloc({required this.eliteReferalValidationUc})
      : super(EliteReferalValidationInitial()) {
    on<EliteReferalValidationSuccessEvent>((event, emit) async {
      emit(EliteReferalValidationLoadingState());
      final result = await eliteReferalValidationUc(event.referalCode);
      result.fold(
        (l) => emit(EliteReferalValidationFailureState(l, l.code, l.messages)),
        (r) => emit(EliteReferalValidationSuccessState(r)),
      );
    });
  }
}
