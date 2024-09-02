import 'package:equatable/equatable.dart';

class WithdrawalEntity extends Equatable {
  final int? transactionId;
  final int? status;
  final String? amount;
  final String? grossAmount;
  final String? serviceFee;
  final String? transactionCode;

  const WithdrawalEntity({
    this.transactionId,
    this.status,
    this.amount,
    this.grossAmount,
    this.serviceFee,
    this.transactionCode,
  });

  @override
  List<Object?> get props => [];
}
