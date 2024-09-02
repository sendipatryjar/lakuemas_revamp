import 'package:equatable/equatable.dart';

class LakuTradePaymentEntity extends Equatable {
  final String? type;
  final String? gold;
  final String? cash;
  final String? tax;
  final String? convert;
  final String? total;
  final String? totalCash;

  const LakuTradePaymentEntity({
    this.type,
    this.gold,
    this.cash,
    this.tax,
    this.convert,
    this.total,
    this.totalCash,
  });

  @override
  List<Object?> get props => [
        type,
        gold,
        cash,
        tax,
        convert,
        total,
        totalCash,
      ];
}
