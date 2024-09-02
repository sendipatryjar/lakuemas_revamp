part of 'get_my_offers_bloc.dart';

sealed class GetMyOffersEvent extends Equatable {
  const GetMyOffersEvent();

  @override
  List<Object> get props => [];
}

class GetMyOffersLoadEvent extends GetMyOffersEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetMyOffersLoadEvent({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}
