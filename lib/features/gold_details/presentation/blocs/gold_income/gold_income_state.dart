part of 'gold_income_bloc.dart';

abstract class GoldIncomeState extends Equatable {
  const GoldIncomeState();

  @override
  List<Object> get props => [];
}

class GoldIncomeInitialState extends GoldIncomeState {}

class GoldIncomeLoadingState extends GoldIncomeState {}

class GoldIncomeSuccessState extends GoldIncomeState {
  final GoldIncomeEntity goldIncomeEntity;

  const GoldIncomeSuccessState(this.goldIncomeEntity);

  @override
  List<Object> get props => [
        [goldIncomeEntity]
      ];
}

class GoldIncomeFailureState extends GoldIncomeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GoldIncomeFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
