import '../../domain/entities/laku_trade_item_entity.dart';

class LakuTradeItemModel extends LakuTradeItemEntity {
  const LakuTradeItemModel({
    String? name,
    String? type,
    String? price,
    String? grade,
    String? weight,
    String? detail,
  }) : super(
          name: name,
          type: type,
          price: price,
          grade: grade,
          weight: weight,
          detail: detail,
        );

  factory LakuTradeItemModel.fromJson(Map<String, dynamic> json) =>
      LakuTradeItemModel(
        name: json['name'],
        type: json['type'],
        price: json['price'],
        grade: json['grade'],
        weight: json['weight'],
        detail: json['detail'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'price': price,
        'grade': grade,
        'weight': weight,
        'detail': detail,
      };
}
