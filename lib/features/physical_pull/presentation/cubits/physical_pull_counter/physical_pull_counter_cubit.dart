import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/physical_pull/data/models/physical_pull_charge_req.dart';

import '../../../../../cores/utils/app_utils.dart';
import '../../../domain/entities/fragment_entity.dart';
import '../physical_pull/physical_pull_cubit.dart';

part 'physical_pull_counter_state.dart';

class PhysicalPullCounterCubit extends Cubit<PhysicalPullCounterState> {
  PhysicalPullCounterCubit()
      : super(const PhysicalPullCounterState(
            enPhysicalPull: EnPhysicalPull.antam));

  // bool? get minPhysicalPull {
  //   final totalGrammation = state.listGoldBrandEntity
  //       .map((e) => e.fragment)
  //       .reduce((a, b) => (a! + b!));

  //   return totalGrammation! >= state.gBalance!.toDouble();
  // }

  // bool? get minChipPhysicalPull {
  //   return state.listGoldBrandEntity.length >= 3;
  // }

  void getGoldBalance(double gBalance) {
    emit(state.copyWith(gBalance: gBalance));
  }

  void changeTab(EnPhysicalPull enPhysicalPull) =>
      emit(state.copyWith(enPhysicalPull: enPhysicalPull));

  void increment(FragmentEntity listGoldBrand) {
    List<FragmentEntity> helper = [];
    List<Map<String, dynamic>> chargeRequest = [];
    helper.addAll(state.listGoldBrandEntity);
    helper.add(listGoldBrand);
    bool minChip = helper.length > 3;
    if (minChip) {
      emit(state.copyWith(isMinChipError: true));
      return;
    }
    double? totalGrammation =
        helper.map((e) => e.fragment).reduce((a, b) => (a! + b!));
    bool isMaxBalance = totalGrammation! >= state.gBalance!.toDouble();
    if (isMaxBalance) {
      emit(state.copyWith(isBalanceError: true));
      return;
    }

    for (var e in helper) {
      final isAvailable =
          chargeRequest.any((element) => element["gold_fragment_id"] == e.id);
      if (isAvailable) {
        break;
      }
      chargeRequest.add(
        PhysicalPullChargeReq(
          goldFragment: e.fragment,
          goldFragmentId: e.id,
          qty: helper.where((element) => element.id == e.id).length,
        ).toJson(),
      );
    }

    final totalCost =
        helper.map((e) => e.certificatePrice).reduce((a, b) => (a! + b!));

    emit(state.copyWith(
      listGoldBrandEntity: helper,
      chargeReq: chargeRequest,
      totalCost: totalCost,
      isMinChipError: false,
      isBalanceError: false,
    ));

    appPrint("${helper.toList()}");
    appPrint("${chargeRequest.toList()}");
  }

  void decrement(FragmentEntity listGoldBrand) {
    List<FragmentEntity> helper = state.listGoldBrandEntity;
    List<Map<String, dynamic>> chargeRequest = [];
    final lastIndex =
        helper.indexWhere((element) => element.id == listGoldBrand.id);
    if (lastIndex != -1) {
      helper.removeAt(lastIndex);
    }
    for (var e in helper) {
      final isAvailable =
          chargeRequest.any((element) => element["gold_fragment_id"] == e.id);
      if (isAvailable) {
        break;
      }
      chargeRequest.add(
        PhysicalPullChargeReq(
          goldFragment: e.fragment,
          goldFragmentId: e.id,
          qty: helper.where((element) => element.id == e.id).isEmpty
              ? 1
              : helper.where((element) => element.id == e.id).length,
        ).toJson(),
      );
    }
    // for (var e in helper) {
    //   final isAvailable =
    //       state.chargeReq.any((element) => element["gold_fragment_id"] == e.id);
    //   if (isAvailable) {
    //     break;
    //   }
    //   if (lastIndex != -1) {
    //   helper.removeAt(lastIndex);
    // }
    // }
    final totalCost = helper.isNotEmpty
        ? helper.map((e) => e.certificatePrice).reduce((a, b) => (a! + b!))
        : 0;
    emit(state.copyWith(
      listGoldBrandEntity: helper,
      totalCost: totalCost,
      chargeReq: chargeRequest,
      isMinChipError: false,
      isBalanceError: false,
    ));

    appPrint("${helper.toList()}");
    appPrint("${chargeRequest.toList()}");
  }
}
