import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/chart_duration_entity.dart';

abstract class IGoldPriceChartRepository {
  Future<Either<AppFailure, ChartDurationEntity>> getChart();
}
