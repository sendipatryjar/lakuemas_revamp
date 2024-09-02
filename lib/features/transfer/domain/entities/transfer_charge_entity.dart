import 'package:equatable/equatable.dart';

class TransferChargeEntity extends Equatable {
  final String? goldWeight;
  final String? accountName;
  final String? accountNumber;
  final String? transactionKey;

  const TransferChargeEntity(
      {this.goldWeight,
      this.accountName,
      this.accountNumber,
      this.transactionKey});

  @override
  List<Object?> get props => [
        goldWeight,
        accountName,
        accountNumber,
        transactionKey,
      ];
}
