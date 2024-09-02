import 'package:equatable/equatable.dart';

class EliteHistoryEntity extends Equatable {
  final int? packageMonth;
  final int? status;
  final String? code;
  final String? createdAt;
  final String? nominal;
  final String? paymentMethod;

  const EliteHistoryEntity({
    this.packageMonth,
    this.status,
    this.code,
    this.createdAt,
    this.nominal,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
        packageMonth,
        status,
        code,
        createdAt,
        nominal,
        paymentMethod,
      ];
}
