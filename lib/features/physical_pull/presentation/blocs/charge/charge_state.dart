part of 'charge_bloc.dart';

abstract class ChargeState extends Equatable {
  const ChargeState();

  @override
  List<Object> get props => [];
}

class ChargeInitialState extends ChargeState {}

class ChargeLoadingState extends ChargeState {}

class ChargeSuccessState extends ChargeState {
  final CheckoutEntity chargeEntity;

  const ChargeSuccessState(this.chargeEntity);

  @override
  List<Object> get props => [chargeEntity];
}

class ChargeFailureState extends ChargeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ChargeFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
