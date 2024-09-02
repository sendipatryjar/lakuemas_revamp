import 'package:equatable/equatable.dart';

import 'chart_entity.dart';

class ChartDurationEntity extends Equatable {
  final List<ChartEntity> sevenDaysAgo;
  final List<ChartEntity> oneMonthAgo;
  final List<ChartEntity> threeMonthsAgo;
  final List<ChartEntity> sixMonthsAgo;

  const ChartDurationEntity({
    this.sevenDaysAgo = const [],
    this.oneMonthAgo = const [],
    this.threeMonthsAgo = const [],
    this.sixMonthsAgo = const [],
  });

  @override
  List<Object?> get props => [
        sevenDaysAgo,
        oneMonthAgo,
        threeMonthsAgo,
        sixMonthsAgo,
      ];
}
