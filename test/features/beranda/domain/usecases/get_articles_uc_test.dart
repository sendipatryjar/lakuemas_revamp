import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/article/domain/entities/article_entity.dart';
import 'package:lakuemas/features/beranda/domain/usecases/get_articles_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_menus_uc_test.mocks.dart';

void main() {
  late MockIBerandaRepository mockIBerandaRepository;
  late BerandaGetArticlesUc berandaGetArticlesUc;
  late List<ArticleEntity> articles;

  setUpAll(() {
    mockIBerandaRepository = MockIBerandaRepository();
    berandaGetArticlesUc =
        BerandaGetArticlesUc(repository: mockIBerandaRepository);
    articles = const [
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
    ];
  });

  group('Beranda Get Articles Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBerandaRepository.getArticles(
          limit: '15',
          page: '1',
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Right(articles));

        final result = await berandaGetArticlesUc();

        expect(result, Right(articles));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBerandaRepository.getArticles(
          limit: '15',
          page: '1',
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await berandaGetArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBerandaRepository.getArticles(
          limit: '15',
          page: '1',
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await berandaGetArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBerandaRepository.getArticles(
          limit: '15',
          page: '1',
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await berandaGetArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBerandaRepository.getArticles(
          limit: '15',
          page: '1',
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await berandaGetArticlesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
