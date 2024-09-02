part of 'balance_bloc.dart';

abstract class QRTransferBalanceState extends Equatable {
  const QRTransferBalanceState();

  @override
  List<Object> get props => [];
}

class QRTransferInitialState extends QRTransferBalanceState {}

class QRTransferLoadingState extends QRTransferBalanceState {}

class QRTransferSuccessState extends QRTransferBalanceState {
  final BalanceEntity? goldBalanceEntity;
  final String? name;

  const QRTransferSuccessState({
    this.goldBalanceEntity,
    this.name,
  });

  @override
  List<Object> get props => [
        [goldBalanceEntity, name]
      ];
}

class QrTransferFailureState extends QRTransferBalanceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const QrTransferFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
