part of 'withdrawal_bloc.dart';

sealed class WithdrawalEvent extends Equatable {
  const WithdrawalEvent();

  @override
  List<Object> get props => [];
}

class WithdrawalNowEvent extends WithdrawalEvent {
  final int? amount;

  const WithdrawalNowEvent(this.amount);

  @override
  List<Object> get props => [
        [amount]
      ];
}
