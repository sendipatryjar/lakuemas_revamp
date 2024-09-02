part of 'balance_bloc.dart';

abstract class QRTransferBalanceEvent extends Equatable {
  const QRTransferBalanceEvent();

  @override
  List<Object> get props => [];
}

class QRTransferBalanceGetEvent extends QRTransferBalanceEvent {
  final String? accountName;

  const QRTransferBalanceGetEvent({this.accountName});
}
