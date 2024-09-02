import 'package:equatable/equatable.dart';

class DetailChargeEntity extends Equatable {
  final double? goldFragment;
  final int? qty;
  final String? goldBrand;
  final String? totalCertificateCost;

  const DetailChargeEntity({
    this.goldFragment,
    this.qty,
    this.goldBrand,
    this.totalCertificateCost,
  });

  @override
  List<Object?> get props => [
        goldFragment,
        qty,
        goldBrand,
        totalCertificateCost,
      ];
}
