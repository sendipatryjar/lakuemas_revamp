part of 'list_gold_brand_bloc.dart';

abstract class ListGoldBrandEvent extends Equatable {
  const ListGoldBrandEvent();

  @override
  List<Object> get props => [];
}

class GetListGoldBrandEvent extends ListGoldBrandEvent {}
