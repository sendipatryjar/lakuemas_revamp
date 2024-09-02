import 'package:dartz/dartz.dart';
import '../../../../features/profile/domain/entities/country_entity.dart';
import '../../../../features/profile/domain/entities/detail_district_entity.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/district_entity.dart';
import '../../domain/entities/province_entity.dart';
import '../../domain/repositories/i_address_repository.dart';
import '../data_sources/interfaces/i_address_remote_data_source.dart';
import '../models/address_req.dart';

class AddressRepository implements IAddressRepository {
  final IAddressRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  AddressRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, List<CountryEntity>>> getCountries(
      {int? limit, int? page, String? sortBy, String? orderBy}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getCountries(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: AddressReq(
            limit: limit,
            page: page,
            sortBy: sortBy,
            orderBy: orderBy,
          ),
        );
        return Right(result.data!);
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
        appPrint("[$this][getCountries][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<ProvinceEntity>>> getProvinces(
      {int? limit, int? page, String? sortBy, String? orderBy}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getProvinces(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: AddressReq(
            limit: limit,
            page: page,
            sortBy: sortBy,
            orderBy: orderBy,
          ),
        );
        return Right(result.data!);
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
        appPrint("[$this][getProvinces][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<CityEntity>>> getCities({
    int? limit,
    int? page,
    int? provinceId,
    String? sortBy,
    String? orderBy,
    String? keyword,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getCities(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: AddressReq(
            limit: limit,
            page: page,
            provinceId: provinceId,
            sortBy: sortBy,
            orderBy: orderBy,
            keyword: keyword,
          ),
        );
        return Right(result.data!);
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
        appPrint("[$this][getProvinces][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<DistrictEntity>>> getDistricts(
      {int? limit,
      int? page,
      int? cityId,
      String? sortBy,
      String? orderBy}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getDistricts(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: AddressReq(
            limit: limit,
            page: page,
            cityId: cityId,
            sortBy: sortBy,
            orderBy: orderBy,
          ),
        );
        return Right(result.data!);
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
        appPrint("[$this][getProvinces][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, DetailDistrictEntity>> getDetailDistrict(
      {int? id}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getDetailDistrict(
          accessToken: accessToken,
          refreshToken: refreshToken,
          id: id,
        );
        return Right(result.data!);
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
        appPrint("[$this][getDetailDistrict][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
