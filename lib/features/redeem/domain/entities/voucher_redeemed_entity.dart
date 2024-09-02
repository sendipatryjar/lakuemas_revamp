import 'package:equatable/equatable.dart';

class VoucherRedeemedEntity extends Equatable {
  final int? transactionId;
  final int? status;
  final String? statusLabel;
  final String? transactionCode;
  final String? goldRedeemed;

  const VoucherRedeemedEntity({
    this.transactionId,
    this.status,
    this.statusLabel,
    this.transactionCode,
    this.goldRedeemed,
  });

  @override
  List<Object?> get props => [
        transactionId,
        status,
        statusLabel,
        transactionCode,
        goldRedeemed,
      ];
}
