part of 'pricing_bloc.dart';

abstract class PricingEvent extends Equatable {
  const PricingEvent();

  @override
  List<Object> get props => [];
}

class PricingGetEvent extends PricingEvent {
  final HelperDataCubit helperDataCubit;

  const PricingGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
