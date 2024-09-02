part of 'elite_confirm_register_bloc.dart';

abstract class EliteConfirmRegisterEvent extends Equatable {
  const EliteConfirmRegisterEvent();

  @override
  List<Object> get props => [];
}

class EliteConfirmRegisterEvents extends EliteConfirmRegisterEvent {
  final int? customerId;

  const EliteConfirmRegisterEvents(
    this.customerId,
  );

  @override
  List<Object> get props => [
        [customerId]
      ];
}
