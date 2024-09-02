import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/transaction/data/models/price_model.dart';
import '../../../../_core/user/data/models/balance_model.dart';
import '../../../../article/data/models/article_model.dart';
import '../../models/menu_model.dart';
import '../../models/promo_model.dart';

abstract class IBerandaRemoteDataSource {
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<MenuModel>> getMenus({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<ArticleModel>> getArticles({
    String? accessToken,
    String? refreshToken,
    String? limit,
    String? page,
    String? orderBy,
    String? sortBy,
  });
  Future<BaseResp<PriceModel>> getPriceSetting({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<PromoModel>> getPromos({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
    String? keyword,
    int? isActive,
  });
  Future<BaseResp<PromoModel>> getPromoById({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
}
