part of 'gold_income_bloc.dart';

abstract class GoldIncomeEvent extends Equatable {
  const GoldIncomeEvent();

  @override
  List<Object> get props => [];
}

class GoldIncomeGetEvent extends GoldIncomeEvent {}
