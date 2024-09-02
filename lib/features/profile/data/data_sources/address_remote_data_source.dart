import '../../../../cores/models/base_resp.dart';

import '../../../../features/profile/data/models/detail_district_model.dart';

import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/address_req.dart';
import '../models/country_model.dart';
import '../models/get_city_model.dart';
import '../models/get_district_model.dart';
import '../models/get_province_model.dart';
import 'interfaces/i_address_remote_data_source.dart';

class AddressRemoteDataSource implements IAddressRemoteDataSource {
  final ApiService apiService;

  AddressRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<CountryModel>> getCountries({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.countries,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, CountryModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<GetProvinceModel>> getProvinces({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.provinces,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, GetProvinceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<GetCityModel>> getCities({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.cities,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, GetCityModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<GetDistrictModel>> getDistricts({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.districts,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, GetDistrictModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailDistrictModel>> getDetailDistrict({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.district}/$id',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
          result.data,
          DetailDistrictModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }
}
