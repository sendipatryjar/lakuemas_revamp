part of 'physical_pull_counter_cubit.dart';

class PhysicalPullCounterState extends Equatable {
  final EnPhysicalPull enPhysicalPull;
  final List<FragmentEntity> listGoldBrandEntity;
  final double? gBalance;
  final int? totalCost;
  final List<Map<String, dynamic>> chargeReq;
  final bool isMinChipError;
  final bool isBalanceError;

  const PhysicalPullCounterState({
    required this.enPhysicalPull,
    this.listGoldBrandEntity = const [],
    this.gBalance,
    this.totalCost,
    this.chargeReq = const [],
    this.isMinChipError = false,
    this.isBalanceError = false,
  });

  PhysicalPullCounterState copyWith({
    EnPhysicalPull? enPhysicalPull,
    List<FragmentEntity>? listGoldBrandEntity,
    double? gBalance,
    bool? minPhysicalPull,
    int? totalCost,
    List<Map<String, dynamic>>? chargeReq,
    bool? isMinChipError,
    bool? isBalanceError,
  }) =>
      PhysicalPullCounterState(
        enPhysicalPull: enPhysicalPull ?? this.enPhysicalPull,
        listGoldBrandEntity: listGoldBrandEntity ?? this.listGoldBrandEntity,
        gBalance: gBalance ?? this.gBalance,
        totalCost: totalCost ?? this.totalCost,
        chargeReq: chargeReq ?? this.chargeReq,
        isMinChipError: isMinChipError ?? this.isMinChipError,
        isBalanceError: isBalanceError ?? this.isBalanceError,
      );

  @override
  List<Object> get props => [
        [
          enPhysicalPull,
          listGoldBrandEntity,
          gBalance,
          totalCost,
          chargeReq,
          isMinChipError,
          isBalanceError,
        ]
      ];
}
