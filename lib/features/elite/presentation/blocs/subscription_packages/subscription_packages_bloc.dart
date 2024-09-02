import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/subscription_packages_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'subscription_packages_event.dart';
part 'subscription_packages_state.dart';

class SubscriptionPackagesBloc
    extends Bloc<SubscriptionPackagesEvent, SubscriptionPackagesState> {
  final SubscriptionPackagesUc getSubscriptionPackagesUc;
  SubscriptionPackagesBloc({required this.getSubscriptionPackagesUc})
      : super(SubscriptionPackagesInitial()) {
    on<GetSubscriptionPackagesEvent>((event, emit) async {
      emit(SubscriptionPackagesLoadingState());
      final result = await getSubscriptionPackagesUc();
      result.fold(
        (l) => emit(SubscriptionPackagesFailureState(l, l.code, l.messages)),
        (r) => emit(SubscriptionPackagesSuccessState(r)),
      );
    });
  }
}
