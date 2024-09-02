import 'package:equatable/equatable.dart';

class LakuTradeItemEntity extends Equatable {
  final String? name;
  final String? type;
  final String? price;
  final String? grade;
  final String? weight;
  final String? detail;

  const LakuTradeItemEntity({
    this.name,
    this.type,
    this.price,
    this.grade,
    this.weight,
    this.detail,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        price,
        grade,
        weight,
        detail,
      ];
}
