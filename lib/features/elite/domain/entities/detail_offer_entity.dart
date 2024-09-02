import 'package:equatable/equatable.dart';

class DetailOfferEntity extends Equatable {
  final int? id;
  final String? image;
  final String? title;
  final String? description;
  final bool? isAllowedRedeem;
  final String? voucherCode;
  final String? refreshTime;
  final String? dailyRefresh;
  final int? voucherAvailable;
  //
  final String? redeemDate;
  final String? validUntil;

  const DetailOfferEntity({
    this.id,
    this.image,
    this.title,
    this.description,
    this.isAllowedRedeem,
    this.voucherCode,
    this.refreshTime,
    this.dailyRefresh,
    this.voucherAvailable,
    //
    this.redeemDate,
    this.validUntil,
  });

  @override
  List<Object?> get props => [
        id,
        image,
        title,
        description,
        isAllowedRedeem,
        voucherCode,
        refreshTime,
        dailyRefresh,
        voucherAvailable,
        //
        redeemDate,
        validUntil,
      ];
}
