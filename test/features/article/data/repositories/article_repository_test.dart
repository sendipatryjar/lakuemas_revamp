import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/models/data_with_meta.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/article/data/data_sources/interfaces/i_article_remote_data_source.dart';
import 'package:lakuemas/features/article/data/models/article_model.dart';
import 'package:lakuemas/features/article/data/repositories/article_repository.dart';
import 'package:lakuemas/features/article/domain/entities/article_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'article_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  IArticleRemoteDataSource,
])
void main() {
  late MockIArticleRemoteDataSource mockIArticleRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late ArticleRepository articleRepository;

  setUpAll(() {
    mockIArticleRemoteDataSource = MockIArticleRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    articleRepository = ArticleRepository(
      remoteDataSource: mockIArticleRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('article repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('get articles', () {
      late List<ArticleModel> valueData;
      late Map<String, dynamic> meta;
      setUp(
        () {
          valueData = [
            ArticleModel.fromJson(const {
              'id': 1,
              'title': 'title',
              'page_title': 'pageTitle',
              'permalink': 'permalink',
              'sm_text': 'smText',
              'mid_text': 'midText',
              'content': 'content',
              'image': 'image',
              'created_at': 'createdAt',
              'updated_at': 'updatedAt',
            })
          ];
          meta = {};
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIArticleRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          )).thenAnswer((realInvocation) async => BaseListResp<ArticleModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
                meta: meta,
              ));

          final result = await articleRepository.getArticles(
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          );

          expect(
              result,
              Right<AppFailure, DataWithMeta<List<ArticleEntity>>>(
                  DataWithMeta(valueData, meta)));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIArticleRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          )).thenThrow(SessionException());

          final result = await articleRepository.getArticles(
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientException 400 or 422',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIArticleRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await articleRepository.getArticles(
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerException 500',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIArticleRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          )).thenThrow(ServerException(false));

          final result = await articleRepository.getArticles(
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownException',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIArticleRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          )).thenThrow(UnknownException('unknown'));

          final result = await articleRepository.getArticles(
            limit: 10,
            page: 1,
            orderBy: 'created_at',
            sortBy: 'desc',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
