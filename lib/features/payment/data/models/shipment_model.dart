import '../../domain/entities/shipment_entity.dart';

class ShipmentModel extends ShipmentEntity {
  const ShipmentModel({
    String? type,
    String? storeName,
    String? address,
    String? expidition,
    String? receiptNumber,
  }) : super(
          type: type,
          storeName: storeName,
          address: address,
          expidition: expidition,
          receiptNumber: receiptNumber,
        );

  factory ShipmentModel.fromJson(Map<String, dynamic> json) => ShipmentModel(
        type: json["type"],
        storeName: json["store_name"],
        address: json["address"],
        expidition: json["expidition"],
        receiptNumber: json["receipt_number"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "store_name": storeName,
        "address": address,
        "expidition": expidition,
        "receipt_number": receiptNumber,
      };
}
