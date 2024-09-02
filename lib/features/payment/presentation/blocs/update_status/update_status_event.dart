part of 'update_status_bloc.dart';

abstract class UpdateStatusEvent extends Equatable {
  const UpdateStatusEvent();

  @override
  List<Object> get props => [];
}

class UpdateStatusPressedEvent extends UpdateStatusEvent {
  final String trxCode;

  const UpdateStatusPressedEvent(this.trxCode);

  @override
  List<Object> get props => [trxCode];
}
