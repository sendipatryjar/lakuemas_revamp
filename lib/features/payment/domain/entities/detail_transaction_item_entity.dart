import 'package:equatable/equatable.dart';

class DetailTransactionItemEntity extends Equatable {
  final String? weight;
  final String? brand;
  final String? storeName;
  final String? storeAddress;

  const DetailTransactionItemEntity({
    this.weight,
    this.brand,
    this.storeName,
    this.storeAddress,
  });

  @override
  List<Object?> get props => [weight, brand, storeName, storeAddress];
}
