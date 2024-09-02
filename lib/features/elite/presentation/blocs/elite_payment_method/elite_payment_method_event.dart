part of 'elite_payment_method_bloc.dart';

abstract class ElitePaymentMethodEvent extends Equatable {
  const ElitePaymentMethodEvent();

  @override
  List<Object> get props => [];
}

class GetElitePaymentMethodEvent extends ElitePaymentMethodEvent {}
