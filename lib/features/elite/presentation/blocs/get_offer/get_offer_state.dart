part of 'get_offer_bloc.dart';

sealed class GetOfferState extends Equatable {
  const GetOfferState();

  @override
  List<Object> get props => [];
}

final class GetOfferInitial extends GetOfferState {}

final class GetOfferLoadingState extends GetOfferState {}

final class GetOfferSuccessState extends GetOfferState {
  final DetailOfferEntity detailOfferEntity;

  const GetOfferSuccessState(this.detailOfferEntity);

  @override
  List<Object> get props => [
        [detailOfferEntity],
      ];
}

final class GetOfferFailureState extends GetOfferState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetOfferFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
