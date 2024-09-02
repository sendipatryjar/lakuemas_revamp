import 'package:equatable/equatable.dart';

class VoucherReferralEntity extends Equatable {
  final String? validUntil;
  final String? createdAt;
  final String? voucherCode;
  final String? status;
  final String? bonusReferral;

  const VoucherReferralEntity(
      {this.validUntil,
      this.createdAt,
      this.voucherCode,
      this.status,
      this.bonusReferral});

  @override
  List<Object?> get props => [
        validUntil,
        createdAt,
        voucherCode,
        status,
        bonusReferral,
      ];
}
