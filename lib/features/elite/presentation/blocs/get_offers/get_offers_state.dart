part of 'get_offers_bloc.dart';

sealed class GetOffersState extends Equatable {
  const GetOffersState();

  @override
  List<Object> get props => [];
}

final class GetOffersInitial extends GetOffersState {}

final class GetOffersLoadingState extends GetOffersState {}

final class GetOffersSuccessState extends GetOffersState {
  final List<OfferEntity> offerEntity;

  const GetOffersSuccessState(this.offerEntity);

  @override
  List<Object> get props => [
        [offerEntity],
      ];
}

final class GetOffersFailureState extends GetOffersState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetOffersFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
