import 'package:equatable/equatable.dart';

class PhysicalPullCheckoutEntity extends Equatable {
  final int? transactionId;
  final int? status;
  final String? transactionCode;
  final String? grossAmount;
  final String? amount;
  final String? serviceFee;
  final String? deliveryFee;
  final String? insuranceFee;

  const PhysicalPullCheckoutEntity({
    this.transactionId,
    this.status,
    this.transactionCode,
    this.grossAmount,
    this.amount,
    this.serviceFee,
    this.deliveryFee,
    this.insuranceFee,
  });

  @override
  List<Object?> get props => [
        transactionId,
        status,
        transactionCode,
        grossAmount,
        amount,
        serviceFee,
        deliveryFee,
        insuranceFee,
      ];
}
