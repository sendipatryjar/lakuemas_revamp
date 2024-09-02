part of 'sgold_pricing_bloc.dart';

abstract class SgoldPricingState extends Equatable {
  const SgoldPricingState();

  @override
  List<Object> get props => [];
}

class SgoldPricingInitialState extends SgoldPricingState {}

class SgoldPricingLoadingState extends SgoldPricingState {}

class SgoldPricingSuccessState extends SgoldPricingState {
  final PriceEntity? priceEntity;

  const SgoldPricingSuccessState({this.priceEntity});

  @override
  List<Object> get props => [
        [priceEntity]
      ];
}

class SgoldPricingFailureState extends SgoldPricingState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SgoldPricingFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
