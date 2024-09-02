part of 'withdrawal_pricing_bloc.dart';

abstract class WithdrawalPricingEvent extends Equatable {
  const WithdrawalPricingEvent();

  @override
  List<Object> get props => [];
}

class WithdrawalPricingGetEvent extends WithdrawalPricingEvent {
  final HelperDataCubit helperDataCubit;

  const WithdrawalPricingGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
