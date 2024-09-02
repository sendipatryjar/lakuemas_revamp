// Mocks generated by Mockito 5.4.4 from annotations
// in lakuemas/test/features/beranda/domain/usecases/get_menus_uc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:lakuemas/cores/errors/app_failure.dart' as _i5;
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart'
    as _i9;
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart'
    as _i6;
import 'package:lakuemas/features/article/domain/entities/article_entity.dart'
    as _i8;
import 'package:lakuemas/features/beranda/domain/entities/menu_entity.dart'
    as _i7;
import 'package:lakuemas/features/beranda/domain/entities/promo_entity.dart'
    as _i10;
import 'package:lakuemas/features/beranda/domain/repositories/i_beranda_repository.dart'
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

/// A class which mocks [IBerandaRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIBerandaRepository extends _i1.Mock
    implements _i3.IBerandaRepository {
  MockIBerandaRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, List<_i6.BalanceEntity>>>
      getBalances() => (super.noSuchMethod(
            Invocation.method(
              #getBalances,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.AppFailure, List<_i6.BalanceEntity>>>.value(
                _FakeEither_0<_i5.AppFailure, List<_i6.BalanceEntity>>(
              this,
              Invocation.method(
                #getBalances,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.AppFailure, List<_i6.BalanceEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, List<_i7.MenuEntity>>> getMenus() =>
      (super.noSuchMethod(
        Invocation.method(
          #getMenus,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, List<_i7.MenuEntity>>>.value(
                _FakeEither_0<_i5.AppFailure, List<_i7.MenuEntity>>(
          this,
          Invocation.method(
            #getMenus,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, List<_i7.MenuEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, List<_i8.ArticleEntity>>> getArticles({
    String? limit,
    String? page,
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
        returnValue: _i4
            .Future<_i2.Either<_i5.AppFailure, List<_i8.ArticleEntity>>>.value(
            _FakeEither_0<_i5.AppFailure, List<_i8.ArticleEntity>>(
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
      ) as _i4.Future<_i2.Either<_i5.AppFailure, List<_i8.ArticleEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i9.PriceEntity>> getPriceSetting() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPriceSetting,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i9.PriceEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i9.PriceEntity>(
          this,
          Invocation.method(
            #getPriceSetting,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i9.PriceEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, List<_i10.PromoEntity>>> getPromos({
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
    String? keyword,
    int? isActive,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPromos,
          [],
          {
            #limit: limit,
            #page: page,
            #orderBy: orderBy,
            #sortBy: sortBy,
            #keyword: keyword,
            #isActive: isActive,
          },
        ),
        returnValue: _i4
            .Future<_i2.Either<_i5.AppFailure, List<_i10.PromoEntity>>>.value(
            _FakeEither_0<_i5.AppFailure, List<_i10.PromoEntity>>(
          this,
          Invocation.method(
            #getPromos,
            [],
            {
              #limit: limit,
              #page: page,
              #orderBy: orderBy,
              #sortBy: sortBy,
              #keyword: keyword,
              #isActive: isActive,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, List<_i10.PromoEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.AppFailure, _i10.PromoEntity>> getPromoById(
          {int? id}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPromoById,
          [],
          {#id: id},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppFailure, _i10.PromoEntity>>.value(
                _FakeEither_0<_i5.AppFailure, _i10.PromoEntity>(
          this,
          Invocation.method(
            #getPromoById,
            [],
            {#id: id},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppFailure, _i10.PromoEntity>>);
}
