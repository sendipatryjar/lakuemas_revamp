part of 'redeem_offer_bloc.dart';

sealed class RedeemOfferEvent extends Equatable {
  const RedeemOfferEvent();

  @override
  List<Object> get props => [];
}

class RedeemOfferPostEvent extends RedeemOfferEvent {
  final int id;

  const RedeemOfferPostEvent({required this.id});

  @override
  List<Object> get props => [
        [id]
      ];
}
