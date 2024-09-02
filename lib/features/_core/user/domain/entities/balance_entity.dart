import 'package:equatable/equatable.dart';

class BalanceEntity extends Equatable {
  final int? customerId;
  final int? paymentMethodId;
  final int? transactionStatus;
  final double? nominalBalance;
  final String? gramationBalance;
  final String? accountNumber;
  final String? transactionCode;
  final String? type;

  const BalanceEntity({
    this.customerId,
    this.paymentMethodId,
    this.transactionStatus,
    this.nominalBalance,
    this.gramationBalance,
    this.accountNumber,
    this.transactionCode,
    this.type,
  });

  @override
  List<Object?> get props => [
        customerId,
        paymentMethodId,
        transactionStatus,
        nominalBalance,
        gramationBalance,
        accountNumber,
        transactionCode,
        type,
      ];
}
