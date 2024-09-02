part of 'get_offer_bloc.dart';

sealed class GetOfferEvent extends Equatable {
  const GetOfferEvent();

  @override
  List<Object> get props => [];
}

class GetOfferDetailEvent extends GetOfferEvent {
  final int id;

  const GetOfferDetailEvent({required this.id});

  @override
  List<Object> get props => [
        [id]
      ];
}

class GetMyOfferDetailEvent extends GetOfferEvent {
  final int id;

  const GetMyOfferDetailEvent({required this.id});

  @override
  List<Object> get props => [
        [id]
      ];
}
