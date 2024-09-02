import 'package:equatable/equatable.dart';

class ChartEntity extends Equatable {
  final double? purchaseePrice;
  final double? sellingPrice;
  final String? activeDate;

  const ChartEntity({
    this.purchaseePrice,
    this.sellingPrice,
    this.activeDate,
  });

  @override
  List<Object?> get props => [purchaseePrice, sellingPrice, activeDate];
}
