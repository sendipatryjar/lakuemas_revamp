import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subscription_packages_state.dart';

class SubscriptionPackagesCubit extends Cubit<SubscriptionPackagesStateCubit> {
  SubscriptionPackagesCubit()
      : super(const SubscriptionPackagesStateCubit(index: null));

  void changeOption(int? packageId, double? totGrammation) {
    emit(state.copyWith(
      index: packageId,
      totGrammation: totGrammation,
    ));
  }
}
