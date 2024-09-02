part of 'redeem_bloc.dart';

abstract class RedeemEvent extends Equatable {
  const RedeemEvent();

  @override
  List<Object> get props => [];
}

class RedeemNowEvent extends RedeemEvent {
  final String? voucherCode;
  final double? goldRedeemed;

  const RedeemNowEvent({this.voucherCode, this.goldRedeemed});

  @override
  List<Object> get props => [
        [voucherCode, goldRedeemed]
      ];
}
