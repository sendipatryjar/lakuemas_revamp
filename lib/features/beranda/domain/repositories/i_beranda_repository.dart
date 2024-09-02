import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../../../article/domain/entities/article_entity.dart';
import '../entities/menu_entity.dart';
import '../entities/promo_entity.dart';

abstract class IBerandaRepository {
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances();
  Future<Either<AppFailure, List<MenuEntity>>> getMenus();
  Future<Either<AppFailure, List<ArticleEntity>>> getArticles({
    String? limit,
    String? page,
    String? orderBy,
    String? sortBy,
  });
  Future<Either<AppFailure, PriceEntity>> getPriceSetting();
  Future<Either<AppFailure, List<PromoEntity>>> getPromos({
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
    String? keyword,
    int? isActive,
  });
  Future<Either<AppFailure, PromoEntity>> getPromoById({
    int? id,
  });
}
