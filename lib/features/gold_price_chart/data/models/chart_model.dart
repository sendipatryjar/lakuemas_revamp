import '../../domain/entities/chart_entity.dart';

class ChartModel extends ChartEntity {
  const ChartModel({
    double? purchasePrice,
    double? sellingPrice,
    String? activeDate,
  }) : super(
          purchaseePrice: purchasePrice,
          sellingPrice: sellingPrice,
          activeDate: activeDate,
        );

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        purchasePrice: (json['purchase_price'] is double)
            ? json['purchase_price']
            : json['purchase_price'].toDouble(),
        sellingPrice: (json['selling_price'] is double)
            ? json['selling_price']
            : json['selling_price'].toDouble(),
        activeDate: json['active_date'],
      );

  Map<String, dynamic> toJson() => {
        'purchase_price': purchaseePrice,
        'selling_price': sellingPrice,
        'active_date': activeDate,
      };
}
