part of 'physical_pull_withdrawal_method_cubit.dart';

class PhysicalPullWithdrawalMethodState extends Equatable {
  final int? index;
  final int? storeId;
  final String? destinationAddress;

  const PhysicalPullWithdrawalMethodState({
    this.index,
    this.storeId,
    this.destinationAddress,
  });

  PhysicalPullWithdrawalMethodState copyWith({
    int? index,
    int? storeId,
    String? destinationAddress,
  }) =>
      PhysicalPullWithdrawalMethodState(
        index: index ?? this.index,
        storeId: storeId ?? this.storeId,
        destinationAddress: destinationAddress ?? this.destinationAddress,
      );

  @override
  List<Object?> get props => [
        index,
        storeId,
        destinationAddress,
      ];
}
