import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/address_req.dart';
import '../../models/country_model.dart';
import '../../models/detail_district_model.dart';
import '../../models/get_city_model.dart';
import '../../models/get_district_model.dart';
import '../../models/get_province_model.dart';

abstract class IAddressRemoteDataSource {
  Future<BaseListResp<CountryModel>> getCountries({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  });
  Future<BaseListResp<GetProvinceModel>> getProvinces({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  });
  Future<BaseListResp<GetCityModel>> getCities({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  });
  Future<BaseListResp<GetDistrictModel>> getDistricts({
    String? accessToken,
    String? refreshToken,
    AddressReq? request,
  });
  Future<BaseResp<DetailDistrictModel>> getDetailDistrict({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
}
