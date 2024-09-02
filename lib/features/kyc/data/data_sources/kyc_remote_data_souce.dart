import 'dart:io';

import 'package:dio/dio.dart';
// ignore: implementation_imports, depend_on_referenced_packages
import 'package:http_parser/src/media_type.dart';

import '../../../../features/kyc/data/models/liveness_url_model.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/user/data/models/user_data_model.dart';
import 'interfaces/i_kyc_remote_data_source.dart';

class KycRemoteDataSource implements IKycRemoteDataSource {
  final ApiService apiService;

  KycRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<UserDataModel>> getUserData({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.customerMe,
      request: {'with_address': true},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, UserDataModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> kycKtp({
    String? nik,
    String? name,
    String? pob,
    String? dob,
    List<int>? ktpPhotoBytes,
    String? accessToken,
    String? refreshToken,
  }) async {
    final file = MultipartFile.fromBytes(
      ktpPhotoBytes!,
      filename: '$nik.jpeg',
      contentType: MediaType("image", "jpeg"),
    );
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.kycKtp,
      useFormData: true,
      request: {
        'ktp_no': nik,
        'name': name,
        'pob': pob,
        'dob': dob,
        'file': file,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> kycSelfie({
    List<int>? selfiePhotoBytes,
    String? accessToken,
    String? refreshToken,
  }) async {
    final file = MultipartFile.fromBytes(
      selfiePhotoBytes!,
      filename:
          'selfie${selfiePhotoBytes.length}${selfiePhotoBytes.first}${selfiePhotoBytes.last}.jpeg',
      contentType: MediaType("image", "jpeg"),
    );
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.kycSelfie,
      useFormData: true,
      request: {
        'file': file,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> kycNpwp({
    String? accessToken,
    String? refreshToken,
    String? npwpNo,
    String? npwpPhotoBytes,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.kycNpwp,
      useFormData: true,
      request: {
        'npwp_no': npwpNo,
        'file': MultipartFile.fromBytes(
          File(npwpPhotoBytes ?? '').readAsBytesSync(),
          filename: '$npwpNo.jpg',
        ),
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> kycSavings({
    String? accessToken,
    String? refreshToken,
    String? accountNumber,
    int? bankId,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.kycSavings,
      request: {
        'account_number': accountNumber,
        'bank_id': bankId,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<LivenessUrlModel>> genrateLivenessUrl(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.kycLivenessPrivy,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, LivenessUrlModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
