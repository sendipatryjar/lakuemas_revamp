import 'package:equatable/equatable.dart';

class StoreBrandEntity extends Equatable {
  final int? id;
  final int? customerId;
  final String? brand;
  final String? createdAt;
  final String? updatedAt;

  const StoreBrandEntity({
    this.id,
    this.customerId,
    this.brand,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        [
          id,
          customerId,
          brand,
          createdAt,
          updatedAt,
        ],
      ];
}
