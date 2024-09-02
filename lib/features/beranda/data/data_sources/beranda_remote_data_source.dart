import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/transaction/data/models/price_model.dart';
import '../../../_core/user/data/models/balance_model.dart';
import '../../../article/data/models/article_model.dart';
import '../models/menu_model.dart';
import '../models/promo_model.dart';
import 'interfaces/i_beranda_remote_data_source.dart';

class BerandaRemoteDataSource implements IBerandaRemoteDataSource {
  final ApiService apiService;

  BerandaRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(apiPath: ApiPath.customerBalance);
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, BalanceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<MenuModel>> getMenus(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(apiPath: ApiPath.menusMobile);
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, MenuModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<ArticleModel>> getArticles({
    String? accessToken,
    String? refreshToken,
    String? limit,
    String? page,
    String? orderBy,
    String? sortBy,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.articles,
      request: {
        ...limit != null ? {'limit': limit} : {},
        ...page != null ? {'page': page} : {},
        ...orderBy != null ? {'order_by': orderBy} : {},
        ...sortBy != null ? {'sort_by': sortBy} : {},
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, ArticleModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<PriceModel>> getPriceSetting(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.priceSetting,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PriceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<PromoModel>> getPromos(
      {String? accessToken,
      String? refreshToken,
      int? limit,
      int? page,
      String? orderBy,
      String? sortBy,
      String? keyword,
      int? isActive}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.promos,
      request: {
        ...limit != null ? {'limit': limit} : {},
        ...page != null ? {'page': page} : {},
        ...orderBy != null ? {'order_by': orderBy} : {},
        ...sortBy != null ? {'sort_by': sortBy} : {},
        ...keyword != null ? {'keyword': keyword} : {},
        'isactive': isActive ?? 1,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, PromoModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<PromoModel>> getPromoById({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.promoDetail}/$id',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PromoModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
