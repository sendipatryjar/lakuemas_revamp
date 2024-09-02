import 'package:equatable/equatable.dart';

class BankMeEntity extends Equatable {
  final int? id;
  final int? customerId;
  final String? name;
  final String? accountName;
  final String? accountNumber;
  final String? logo;
  final String? serviceFee;

  const BankMeEntity({
    this.id,
    this.customerId,
    this.name,
    this.accountName,
    this.accountNumber,
    this.logo,
    this.serviceFee,
  });

  @override
  List<Object?> get props =>
      [id, customerId, name, accountName, accountNumber, logo, serviceFee];
}
