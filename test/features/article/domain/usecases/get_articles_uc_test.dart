import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/models/data_with_meta.dart';
import 'package:lakuemas/features/article/domain/entities/article_entity.dart';
import 'package:lakuemas/features/article/domain/repositories/i_article_repository.dart';
import 'package:lakuemas/features/article/domain/usecases/get_articles_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_articles_uc_test.mocks.dart';

@GenerateMocks([IArticleRepository])
void main() {
  late MockIArticleRepository mockIArticleRepository;
  late GetArticlesUc getArticlesUc;
  late DataWithMeta<List<ArticleEntity>> articles;

  setUpAll(() {
    mockIArticleRepository = MockIArticleRepository();
    getArticlesUc = GetArticlesUc(repository: mockIArticleRepository);
    articles = const DataWithMeta(
      [
        ArticleEntity(
          id: 1,
          content: 'content',
          image: 'image',
          pageTitle: 'pageTitle',
          midText: 'midText',
          smText: 'smText',
          title: 'title',
          permalink: 'permalink',
          createdAt: 'createdAt',
          updatedAt: 'updatedAt',
        ),
      ],
      {
        'limit': 10,
        'page': 1,
        'total_page': 5,
        'total_count': 50,
      },
    );
  });

  group('Get Articles Usecase', () {
    test(
      'Success',
      () async {
        when(mockIArticleRepository.getArticles(
          limit: 10,
          page: 1,
          orderBy: 'orderBy',
          sortBy: 'sortBy',
        )).thenAnswer((realInvocation) async => Right(articles));

        final result = await getArticlesUc(
          limit: 10,
          page: 1,
          orderBy: 'orderBy',
          sortBy: 'sortBy',
        );

        expect(result, Right(articles));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIArticleRepository.getArticles(
          limit: 3,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIArticleRepository.getArticles(
          limit: 3,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIArticleRepository.getArticles(
          limit: 3,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIArticleRepository.getArticles(
          limit: 3,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
