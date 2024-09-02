part of 'dice_gatcha_bloc.dart';

sealed class DiceGatchaEvent extends Equatable {
  const DiceGatchaEvent();

  @override
  List<Object?> get props => [];
}

class DiceGatchaDoNowEvent extends DiceGatchaEvent {
  final int reHitCount;
  final int? qty;

  const DiceGatchaDoNowEvent({required this.reHitCount, required this.qty});

  @override
  List<Object?> get props => [reHitCount, qty];
}
