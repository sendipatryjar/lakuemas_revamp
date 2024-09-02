part of 'pricing_bloc.dart';

abstract class PricingState extends Equatable {
  const PricingState();

  @override
  List<Object> get props => [];
}

class PricingInitialState extends PricingState {}

class PricingLoadingState extends PricingState {}

class PricingSuccessState extends PricingState {
  final PriceEntity? priceEntity;

  const PricingSuccessState({this.priceEntity});

  @override
  List<Object> get props => [
        [priceEntity]
      ];
}

class PricingFailureState extends PricingState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PricingFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
