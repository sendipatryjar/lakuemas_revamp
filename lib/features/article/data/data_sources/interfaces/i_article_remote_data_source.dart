import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/article_model.dart';

abstract class IArticleRemoteDataSource {
  Future<BaseListResp<ArticleModel>> getArticles({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
  });
  Future<BaseResp<ArticleModel>> getArticleById({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
}
