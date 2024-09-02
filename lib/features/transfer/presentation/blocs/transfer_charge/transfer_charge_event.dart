part of 'transfer_charge_bloc.dart';

abstract class TransferChargeEvent extends Equatable {
  const TransferChargeEvent();

  @override
  List<Object> get props => [];
}

class TransferChargeNowEvent extends TransferChargeEvent {
  final bool isAddFavorite;
  final double goldWeight;
  final String accountNumber;
  final String? note;

  const TransferChargeNowEvent({
    required this.isAddFavorite,
    required this.goldWeight,
    required this.accountNumber,
    this.note,
  });

  @override
  List<Object> get props => [
        [isAddFavorite, goldWeight, accountNumber, note]
      ];
}

class TransferChargeInitEvent extends TransferChargeEvent {}
