part of 'redeem_check_bloc.dart';

abstract class RedeemCheckState extends Equatable {
  const RedeemCheckState();

  @override
  List<Object> get props => [];
}

class RedeemCheckInitialState extends RedeemCheckState {}

class RedeemCheckLoadingState extends RedeemCheckState {}

class RedeemCheckSuccessState extends RedeemCheckState {
  final VoucherRedeemEntity? voucherRedeemEntity;

  const RedeemCheckSuccessState({this.voucherRedeemEntity});

  @override
  List<Object> get props => [
        [voucherRedeemEntity]
      ];
}

class RedeemCheckFailureState extends RedeemCheckState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const RedeemCheckFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
