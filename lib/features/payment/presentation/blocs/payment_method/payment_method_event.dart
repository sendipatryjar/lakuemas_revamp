part of 'payment_method_bloc.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();

  @override
  List<Object?> get props => [];
}

class PaymentMethodsGetEvent extends PaymentMethodEvent {
  final String? actionType;
  final HelperDataCubit helperDataCubit;

  const PaymentMethodsGetEvent(this.actionType, this.helperDataCubit);

  @override
  List<Object?> get props => [actionType, helperDataCubit];
}
