import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final int? id;
  final String? image;
  final String? title;
  final String? redeemDate;
  final String? validUntil;

  const OfferEntity({
    this.id,
    this.image,
    this.title,
    this.redeemDate,
    this.validUntil,
  });

  @override
  List<Object?> get props => [
        id,
        image,
        title,
        redeemDate,
        validUntil,
      ];
}
