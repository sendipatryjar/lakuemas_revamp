part of 'transfer_charge_bloc.dart';

abstract class TransferChargeState extends Equatable {
  const TransferChargeState();

  @override
  List<Object> get props => [];
}

class TransferChargeInitialState extends TransferChargeState {}

class TransferChargeLoadingState extends TransferChargeState {}

class TransferChargeSuccessState extends TransferChargeState {
  final TransferChargeEntity? transferChargeEntity;

  const TransferChargeSuccessState(this.transferChargeEntity);

  @override
  List<Object> get props => [
        [transferChargeEntity]
      ];
}

class TransferChargeFailureState extends TransferChargeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const TransferChargeFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
