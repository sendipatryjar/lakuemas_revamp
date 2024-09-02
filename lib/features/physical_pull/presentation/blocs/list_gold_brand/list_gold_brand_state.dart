part of 'list_gold_brand_bloc.dart';

abstract class ListGoldBrandState extends Equatable {
  const ListGoldBrandState();

  @override
  List<Object> get props => [];
}

class ListGoldBrandInitialState extends ListGoldBrandState {}

class ListGoldBrandLoadingState extends ListGoldBrandState {}

class ListGoldBrandSuccessState extends ListGoldBrandState {
  final List<ListGoldBrandEntity>? listGoldBrandEntity;
  final ListGoldBrandEntity? listAntam;
  final ListGoldBrandEntity? listLotus;

  const ListGoldBrandSuccessState({
    this.listGoldBrandEntity,
    this.listAntam,
    this.listLotus,
  });

  @override
  List<Object> get props => [
        [
          listGoldBrandEntity,
        ]
      ];
}

class ListGoldBrandFailureState extends ListGoldBrandState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ListGoldBrandFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
