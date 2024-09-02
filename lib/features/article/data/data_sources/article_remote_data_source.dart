import '../../../../cores/models/base_resp.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/article_model.dart';
import 'interfaces/i_article_remote_data_source.dart';

class ArticleRemoteDataSource implements IArticleRemoteDataSource {
  final ApiService apiService;

  ArticleRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<ArticleModel>> getArticles(
      {String? accessToken,
      String? refreshToken,
      int? limit,
      int? page,
      String? orderBy,
      String? sortBy}) async {
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
  Future<BaseResp<ArticleModel>> getArticleById({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.articlesDetail}/$id',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, ArticleModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
