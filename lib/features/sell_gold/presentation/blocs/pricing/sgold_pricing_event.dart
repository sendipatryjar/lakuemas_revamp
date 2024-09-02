part of 'sgold_pricing_bloc.dart';

abstract class SgoldPricingEvent extends Equatable {
  const SgoldPricingEvent();

  @override
  List<Object> get props => [];
}

class SgoldPricingGetEvent extends SgoldPricingEvent {
  final HelperDataCubit helperDataCubit;

  const SgoldPricingGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
