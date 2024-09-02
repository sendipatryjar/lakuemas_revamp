import '../../domain/entities/detail_transaction_item_entity.dart';

class DetailTransactionItemModel extends DetailTransactionItemEntity {
  const DetailTransactionItemModel({
    String? weight,
    String? brand,
    String? storeName,
    String? storeAddress,
  }) : super(
          weight: weight,
          brand: brand,
          storeName: storeName,
          storeAddress: storeAddress,
        );

  factory DetailTransactionItemModel.fromJson(Map<String, dynamic> json) =>
      DetailTransactionItemModel(
        weight: json['weight'],
        brand: json['brand'],
        storeName: json['store_name'],
        storeAddress: json['store_address'],
      );

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'brand': brand,
        'store_name': storeName,
        'store_address': storeAddress,
      };
}
