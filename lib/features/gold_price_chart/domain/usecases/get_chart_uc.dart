import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/chart_duration_entity.dart';
import '../repositories/i_gold_price_chart_repository.dart';

class GetChartUc {
  final IGoldPriceChartRepository repository;

  GetChartUc({required this.repository});

  Future<Either<AppFailure, ChartDurationEntity>> call() =>
      repository.getChart();
}
