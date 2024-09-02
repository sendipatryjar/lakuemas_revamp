part of 'unsub_elite_bloc.dart';

sealed class UnsubEliteEvent extends Equatable {
  const UnsubEliteEvent();

  @override
  List<Object> get props => [];
}

class UnsubElitePostEvent extends UnsubEliteEvent {
  final String reason;

  const UnsubElitePostEvent({required this.reason});

  @override
  List<Object> get props => [
        [reason]
      ];
}
