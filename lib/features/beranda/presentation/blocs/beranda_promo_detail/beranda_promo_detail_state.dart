part of 'beranda_promo_detail_bloc.dart';

sealed class BerandaPromoDetailState extends Equatable {
  const BerandaPromoDetailState();

  @override
  List<Object> get props => [];
}

class BerandaPromoDetailInitialState extends BerandaPromoDetailState {}

class BerandaPromoDetailLoadingState extends BerandaPromoDetailState {}

class BerandaPromoDetailSuccessState extends BerandaPromoDetailState {
  final PromoEntity? promo;

  const BerandaPromoDetailSuccessState({
    required this.promo,
  });

  @override
  List<Object> get props => [
        [promo]
      ];
}

class BerandaPromoDetailFailureState extends BerandaPromoDetailState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BerandaPromoDetailFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
