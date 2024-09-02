// Mocks generated by Mockito 5.4.4 from annotations
// in lakuemas/test/features/article/domain/usecases/get_articles_uc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:lakuemas/cores/errors/app_failure.dart' as _i5;
import 'package:lakuemas/cores/models/data_with_meta.dart' as _i6;
import 'package:lakuemas/features/article/domain/entities/article_entity.dart'
    as _i7;
import 'package:lakuemas/features/article/domain/repositories/i_article_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IArticleRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIArticleRepository extends _i1.Mock
    implements _i3.IArticleRepository {
  MockIArticleRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<
          _i2.Either<_i5.AppFailure, _i6.DataWithMeta<List<_i7.ArticleEntity>>>>
      getArticles({
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
  }) =>
          (super.noSuchMethod(
            Invocation.method(
              #getArticles,
              [],
              {
                #limit: limit,
                #page: page,
                #orderBy: orderBy,
                #sortBy: sortBy,
              },
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.AppFailure,
                        _i6.DataWithMeta<List<_i7.ArticleEntity>>>>.value(
                _FakeEither_0<_i5.AppFailure,
                    _i6.DataWithMeta<List<_i7.ArticleEntity>>>(
              this,
              Invocation.method(
                #getArticles,
                [],
                {
                  #limit: limit,
                  #page: page,
                  #orderBy: orderBy,
                  #sortBy: sortBy,
                },
              ),
            )),
          ) as _i4.Future<
              _i2.Either<_i5.AppFailure,
                  _i6.DataWithMeta<List<_i7.ArticleEntity>>>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i7.ArticleEntity>> getArticleById(
          {int? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getArticleById,
          [],
          {#id: id},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i7.ArticleEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i7.ArticleEntity>(
          this,
          Invocation.method(
            #getArticleById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i7.ArticleEntity>>);
}
