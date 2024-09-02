import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/support_contact_entity.dart';
import '../../domain/entities/support_faq_entity.dart';
import '../../domain/repositories/i_support_repository.dart';
import '../data_sources/interfaces/i_support_remote_data_source.dart';

class SupportRepository implements ISupportRepository {
  final ISupportRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  SupportRepository(
      {required this.remoteDataSource, required this.tokenLocalDataSource});

  @override
  Future<Either<AppFailure, List<SupportFaqEntity>>> getFaq(
      {String? keyword}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getFaq(
          accessToken: accessToken,
          refreshToken: refreshToken,
          keyword: keyword,
        );
        return Right(result.data ?? []);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
          code: e.code,
          messages: e.toString(),
          errors: e.errors,
        ));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getFaq][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, SupportContactEntity?>> getSupportContacts() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getSupportContacts(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return Right(result.data);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
          code: e.code,
          messages: e.toString(),
          errors: e.errors,
        ));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][chatUs][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
