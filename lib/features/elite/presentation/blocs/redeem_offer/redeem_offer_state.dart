part of 'redeem_offer_bloc.dart';

sealed class RedeemOfferState extends Equatable {
  const RedeemOfferState();

  @override
  List<Object> get props => [];
}

final class RedeemOfferInitial extends RedeemOfferState {}

final class RedeemOfferLoadingState extends RedeemOfferState {}

final class RedeemOfferSuccessState extends RedeemOfferState {}

final class RedeemOfferFailureState extends RedeemOfferState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const RedeemOfferFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
