part of 'withdrawal_pricing_bloc.dart';

abstract class WithdrawalPricingState extends Equatable {
  const WithdrawalPricingState();

  @override
  List<Object> get props => [];
}

class WithdrawalPricingInitialState extends WithdrawalPricingState {}

class WithdrawalPricingLoadingState extends WithdrawalPricingState {}

class WithdrawalPricingSuccessState extends WithdrawalPricingState {
  final PriceEntity? priceEntity;

  const WithdrawalPricingSuccessState({this.priceEntity});

  @override
  List<Object> get props => [
        [priceEntity]
      ];
}

class WithdrawalPricingFailureState extends WithdrawalPricingState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const WithdrawalPricingFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
