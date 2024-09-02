part of 'beranda_promo_bloc.dart';

abstract class BerandaPromoState extends Equatable {
  const BerandaPromoState();

  @override
  List<Object> get props => [];
}

class BerandaPromosInitialState extends BerandaPromoState {}

class BerandaPromosLoadingState extends BerandaPromoState {}

class BerandaPromosSuccessState extends BerandaPromoState {
  final List<PromoEntity> promoEntities;

  const BerandaPromosSuccessState({
    required this.promoEntities,
  });

  @override
  List<Object> get props => [
        [promoEntities]
      ];
}

class BerandaPromosFailureState extends BerandaPromoState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BerandaPromosFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
