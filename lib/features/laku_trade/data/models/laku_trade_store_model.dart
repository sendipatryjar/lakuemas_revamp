import '../../domain/entities/laku_trade_store_entity.dart';

class LakuTradeStoreModel extends LakuTradeStoreEntity {
  const LakuTradeStoreModel({
    String? name,
    String? address,
  }) : super(
          name: name,
          address: address,
        );

  factory LakuTradeStoreModel.fromJson(Map<String, dynamic> json) =>
      LakuTradeStoreModel(
        name: json['name'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
      };
}
