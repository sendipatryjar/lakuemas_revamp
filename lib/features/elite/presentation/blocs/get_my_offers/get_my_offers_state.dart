part of 'get_my_offers_bloc.dart';

sealed class GetMyOffersState extends Equatable {
  const GetMyOffersState();

  @override
  List<Object> get props => [];
}

final class GetMyOffersInitial extends GetMyOffersState {}

final class GetMyOffersLoadingState extends GetMyOffersState {}

final class GetMyOffersSuccessState extends GetMyOffersState {
  final List<OfferEntity> offerEntity;

  const GetMyOffersSuccessState(this.offerEntity);

  @override
  List<Object> get props => [
        [offerEntity],
      ];
}

final class GetMyOffersFailureState extends GetMyOffersState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetMyOffersFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
