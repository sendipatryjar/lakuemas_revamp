import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../domain/entities/register_entity.dart';
import '../../domain/repositories/i_register_repository.dart';
import '../data_source/interfaces/i_register_remote_data_source.dart';
import '../models/register_req.dart';

class RegisterRepository implements IRegisterRepository {
  final IRegisterRemoteDataSource remoteDataSource;

  RegisterRepository({required this.remoteDataSource});

  @override
  Future<Either<AppFailure, RegisterEntity>> register(
      {required String fullName,
      required String phoneNumber,
      required String email,
      required String password}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        var res = await remoteDataSource.register(RegisterReq(
          name: fullName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        ));
        return Right(res.data!);
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
        appPrint("[$this][register][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, TermsAndConditionsEntity>>
      getTermsAndConditionsRegister() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final result = await remoteDataSource.getTermsAndConditionsRegister();
        return Right(result.data!);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
            code: e.code, messages: e.toString(), errors: e.errors));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getTermsAndConditionsRegister][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, String?>> getPrivacyPolicyRegister() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final result = await remoteDataSource.getPrivacyPolicyRegister();
        return Right(result);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
            code: e.code, messages: e.toString(), errors: e.errors));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getPrivacyPolicyRegister][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
