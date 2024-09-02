import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/chart_duration_entity.dart';
import '../../domain/repositories/i_gold_price_chart_repository.dart';
import '../data_sources/interfaces/i_gold_price_chart_remote_data_source.dart';

class GoldPriceChartRepository implements IGoldPriceChartRepository {
  final IGoldPriceChartRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  GoldPriceChartRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, ChartDurationEntity>> getChart() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getChart(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return Right(result.data!);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(code: e.code, messages: e.toString()));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getChart][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
