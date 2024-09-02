part of 'close_account_bloc.dart';

abstract class CloseAccountEvent extends Equatable {
  const CloseAccountEvent();

  @override
  List<Object> get props => [];
}

class CloseAccountSubmitEvent extends CloseAccountEvent {
  final String reason;

  const CloseAccountSubmitEvent(this.reason);

  @override
  List<Object> get props => [reason];
}
