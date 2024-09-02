import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../data/models/physical_pull_checkout_req.dart';
import '../../../domain/entities/physical_pull_checkout_entity.dart';
import '../../../domain/usecases/physical_pull_checkout_uc.dart';

part 'physical_pull_checkout_event.dart';
part 'physical_pull_checkout_state.dart';

class PhysicalPullCheckoutBloc
    extends Bloc<PhysicalPullCheckoutEvent, PhysicalPullCheckoutState> {
  final PhysicalPullCheckoutUc physicalPullCheckoutUc;
  PhysicalPullCheckoutBloc({required this.physicalPullCheckoutUc})
      : super(PhysicalPullCheckoutInitialState()) {
    on<PhysicalPullCheckoutGetEvent>((event, emit) async {
      emit(PhysicalPullCheckoutLoadingState());
      final result = await physicalPullCheckoutUc(PhysicalPullCheckoutParams(
          physicalPullCheckoutReq: event.physicalPullCheckoutReq));
      result.fold(
        (l) => emit(PhysicalPullCheckoutFailureState(l, l.code, l.messages)),
        (r) => emit(PhysicalPullCheckoutSuccessState(r)),
      );
    });
  }
}
