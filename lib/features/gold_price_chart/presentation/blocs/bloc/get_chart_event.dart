part of 'get_chart_bloc.dart';

sealed class GetChartEvent extends Equatable {
  const GetChartEvent();

  @override
  List<Object> get props => [];
}

class GetChartNowEvent extends GetChartEvent {}
