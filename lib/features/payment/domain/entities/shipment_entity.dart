import 'package:equatable/equatable.dart';

class ShipmentEntity extends Equatable {
  final String? type;
  final String? storeName;
  final String? address;
  final String? expidition;
  final String? receiptNumber;

  const ShipmentEntity({
    this.type,
    this.storeName,
    this.address,
    this.expidition,
    this.receiptNumber,
  });

  @override
  List<Object?> get props => [
        type,
        storeName,
        address,
        expidition,
        receiptNumber,
      ];
}
