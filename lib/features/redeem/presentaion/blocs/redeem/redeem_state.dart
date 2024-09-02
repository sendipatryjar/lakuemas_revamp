part of 'redeem_bloc.dart';

abstract class RedeemState extends Equatable {
  const RedeemState();

  @override
  List<Object> get props => [];
}

class RedeemInitialState extends RedeemState {}

class RedeemLoadingState extends RedeemState {}

class RedeemSuccessState extends RedeemState {
  final VoucherRedeemedEntity? voucherRedeemedEntity;

  const RedeemSuccessState({this.voucherRedeemedEntity});

  @override
  List<Object> get props => [
        [voucherRedeemedEntity]
      ];
}

class RedeemFailureState extends RedeemState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const RedeemFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
