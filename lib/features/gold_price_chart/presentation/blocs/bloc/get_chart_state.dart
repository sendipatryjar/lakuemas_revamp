part of 'get_chart_bloc.dart';

sealed class GetChartState extends Equatable {
  const GetChartState();

  @override
  List<Object> get props => [];
}

class GetChartInitialState extends GetChartState {}

class GetChartLoadingState extends GetChartState {}

class GetChartSuccessState extends GetChartState {
  final ChartDurationEntity? chartDurationEntity;

  const GetChartSuccessState(this.chartDurationEntity);

  @override
  List<Object> get props => [
        [chartDurationEntity]
      ];
}

class GetChartFailureState extends GetChartState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetChartFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
