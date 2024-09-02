part of 'elite_payment_method_bloc.dart';

abstract class ElitePaymentMethodState extends Equatable {
  const ElitePaymentMethodState();

  @override
  List<Object> get props => [];
}

class ElitePaymentMethodInitial extends ElitePaymentMethodState {}

class ElitePaymentMethodLoadingState extends ElitePaymentMethodState {}

class ElitePaymentMethodSuccessState extends ElitePaymentMethodState {
  final List<ElitePaymentMethodEntity> elitePaymentMethodEntity;

  const ElitePaymentMethodSuccessState(this.elitePaymentMethodEntity);

  @override
  List<Object> get props => [
        [elitePaymentMethodEntity]
      ];
}

class ElitePaymentMethodFailureState extends ElitePaymentMethodState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ElitePaymentMethodFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
