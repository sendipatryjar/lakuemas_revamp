part of 'elite_activation_code_bloc.dart';

abstract class EliteActivationCodeEvent extends Equatable {
  const EliteActivationCodeEvent();

  @override
  List<Object> get props => [];
}

class EliteActivationCodeValidationEvent extends EliteActivationCodeEvent {
  final dynamic voucherCode;
  final String? type;

  const EliteActivationCodeValidationEvent(
    this.voucherCode,
    this.type,
  );

  @override
  List<Object> get props => [
        [voucherCode, type]
      ];
}
