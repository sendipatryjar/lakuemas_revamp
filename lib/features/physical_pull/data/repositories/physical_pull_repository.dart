import 'package:dartz/dartz.dart';
import '../../../../features/physical_pull/data/models/physical_pull_checkout_req.dart';
import '../../../../features/physical_pull/domain/entities/physical_pull_checkout_entity.dart';
import '../../../../features/physical_pull/domain/entities/store_entity.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../../domain/entities/list_gold_brand_entity.dart';
import '../../domain/repositories/i_physical_pull_repository.dart';
import '../data_sources/interfaces/i_physical_pull_remote_data_source.dart';

class PhysicalPullRepository implements IPhysicalPullRepository {
  final IPhysicalPullRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  PhysicalPullRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getBalances(
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
        appPrint("[$this][getBalances][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<ListGoldBrandEntity>>>
      getListGoldBrand() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getListGoldBrand(
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
        appPrint("[$this][getListGoldBrand][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<StoreEntity>>> getStore({
    int? limit,
    int? page,
    int? cityId,
    String? sortBy,
    String? orderBy,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getStore(
          accessToken: accessToken,
          refreshToken: refreshToken,
          cityId: cityId,
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
        appPrint("[$this][getListGoldBrand][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, CheckoutEntity>> charge({
    List<Map<String, dynamic>>? listPhysicalPullReq,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.charge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          listPhysicalPullReq: listPhysicalPullReq,
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
        appPrint("[$this][postCharge][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, PhysicalPullCheckoutEntity>> physicalPullCheckout({
    PhysicalPullCheckoutReq? physicalPullCheckoutReq,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.physicalPullCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          physicalPullCheckoutReq: physicalPullCheckoutReq,
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
        appPrint("[$this][physicalPullCheckout][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
