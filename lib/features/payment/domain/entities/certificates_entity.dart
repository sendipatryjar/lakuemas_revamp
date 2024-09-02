import 'package:equatable/equatable.dart';

class CertificatesEntity extends Equatable {
  final int? goldFragment;
  final String? goldBrand;
  final String? certificateCost;

  const CertificatesEntity({
    this.goldFragment,
    this.goldBrand,
    this.certificateCost,
  });

  @override
  List<Object?> get props => [
        goldFragment,
        goldBrand,
        certificateCost,
      ];
}
