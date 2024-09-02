part of 'get_offers_bloc.dart';

sealed class GetOffersEvent extends Equatable {
  const GetOffersEvent();

  @override
  List<Object> get props => [];
}

class GetOffersLoadEvent extends GetOffersEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetOffersLoadEvent({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}
