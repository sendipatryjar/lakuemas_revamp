import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/utils/app_utils.dart';

part 'physical_pull_state.dart';

class PhysicalPullCubit extends Cubit<PhysicalPullState> {
  PhysicalPullCubit()
      : super(const PhysicalPullState(
          enPhysicalPull: EnPhysicalPull.antam,
          isError: false,
        ));

  bool get minPhysicalPull {
    return double.parse(state.totGrammation.toString()).toDouble() <=
        double.parse(state.gBalance.toString()).toDouble();
  }

  void getGoldBalance(double gBalance) {
    emit(state.copyWith(gBalance: gBalance));
  }

  void addPhysicalPullReq(var physicalPullReq) {
    List helper = [];
    helper.addAll(state.physicalPullReq);
    helper.add(physicalPullReq);
    emit(state.copyWith(physicalPullReq: helper));
    appPrint("$helper");
  }

  void changeTab(EnPhysicalPull enPhysicalPull) => emit(state.copyWith(enPhysicalPull: enPhysicalPull, isError: false));
}
