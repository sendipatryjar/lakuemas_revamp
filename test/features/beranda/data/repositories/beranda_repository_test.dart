import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/_core/user/data/models/balance_model.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/article/data/models/article_model.dart';
import 'package:lakuemas/features/beranda/data/data_sources/interfaces/i_beranda_remote_data_source.dart';
import 'package:lakuemas/features/beranda/data/models/menu_model.dart';
import 'package:lakuemas/features/beranda/data/models/promo_model.dart';
import 'package:lakuemas/features/beranda/data/repositories/beranda_repository.dart';
import 'package:lakuemas/features/beranda/domain/entities/promo_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'beranda_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  IBerandaRemoteDataSource,
])
void main() {
  late MockIBerandaRemoteDataSource mockIBerandaRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late BerandaRepository berandaRepository;

  setUpAll(() {
    mockIBerandaRemoteDataSource = MockIBerandaRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    berandaRepository = BerandaRepository(
      remoteDataSource: mockIBerandaRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('beranda repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('get balances', () {
      late List<BalanceModel> valueData;

      setUp(
        () {
          valueData = [
            BalanceModel.fromJson(const {
              'customer_id': 0,
              'payment_method_id': 0,
              'nominal_balance': 100000.0,
              'grammation_balance': '0.2',
              'type': 'gold_balance',
            })
          ];
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getBalances(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseListResp<BalanceModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await berandaRepository.getBalances();

          expect(result, Right<AppFailure, List<BalanceEntity>>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getBalances(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await berandaRepository.getBalances();

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
          when(mockIBerandaRemoteDataSource.getBalances(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await berandaRepository.getBalances();

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
          when(mockIBerandaRemoteDataSource.getBalances(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await berandaRepository.getBalances();

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
          when(mockIBerandaRemoteDataSource.getBalances(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await berandaRepository.getBalances();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get menus', () {
      late List<MenuModel> valueData;
      setUp(
        () {
          valueData = [
            MenuModel.fromJson(const {
              'id': 1,
              'name': 'name',
              'description': 'description',
              'parent_id': 1,
              'position': 1,
              'is_active': 1,
              'created_at': 'createdAt',
              'updated_at': 'updatedAt',
            })
          ];
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getMenus(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseListResp<MenuModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await berandaRepository.getMenus();

          expect(result, Right<AppFailure, List<MenuModel>>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getMenus(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await berandaRepository.getMenus();

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
          when(mockIBerandaRemoteDataSource.getMenus(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await berandaRepository.getMenus();

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
          when(mockIBerandaRemoteDataSource.getMenus(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await berandaRepository.getMenus();

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
          when(mockIBerandaRemoteDataSource.getMenus(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await berandaRepository.getMenus();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('get articles', () {
      late List<ArticleModel> articleModel;
      setUp(
        () {
          articleModel = [
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
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          )).thenAnswer((realInvocation) async => BaseListResp<ArticleModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: articleModel,
              ));

          final result = await berandaRepository.getArticles(
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          );

          expect(result, Right<AppFailure, List<ArticleModel>>(articleModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          )).thenThrow(SessionException());

          final result = await berandaRepository.getArticles(
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
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
          when(mockIBerandaRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await berandaRepository.getArticles(
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
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
          when(mockIBerandaRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          )).thenThrow(ServerException(false));

          final result = await berandaRepository.getArticles(
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
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
          when(mockIBerandaRemoteDataSource.getArticles(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          )).thenThrow(UnknownException('unknown'));

          final result = await berandaRepository.getArticles(
            limit: '10',
            page: '1',
            orderBy: 'orderBy',
            sortBy: 'sortBy',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get price setting', () {
      late PriceModel valueData;

      setUp(
        () {
          valueData = PriceModel.fromJson(const {
            "price": "990000",
            "selling_price": "990000",
            "elite_selling_price": "990000",
            "purchase_price": "990000",
            "elite_purchase_price": "990000",
            "tax_percentage": "3",
            "tax_nominal": "3000",
            "minimum_nominal": "50000",
            "minimum_grammation": "0.0506",
            "placeholder_nominal": ["100000", "200000", "300000"],
            "placeholder_grammation": ["1.00", "2.00", "3.00"]
          });
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getPriceSetting(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseResp<PriceModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await berandaRepository.getPriceSetting();

          expect(result, Right<AppFailure, PriceEntity>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getPriceSetting(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await berandaRepository.getPriceSetting();

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
          when(mockIBerandaRemoteDataSource.getPriceSetting(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await berandaRepository.getPriceSetting();

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
          when(mockIBerandaRemoteDataSource.getPriceSetting(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await berandaRepository.getPriceSetting();

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
          when(mockIBerandaRemoteDataSource.getPriceSetting(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await berandaRepository.getPriceSetting();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get promos', () {
      late List<PromoModel> promoModel;
      setUp(
        () {
          promoModel = const [
            PromoModel(
              id: 1,
              title: 'title',
              content: 'content',
              image: 'image',
            )
          ];
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getPromos(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          )).thenAnswer((realInvocation) async => BaseListResp<PromoModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: promoModel,
              ));

          final result = await berandaRepository.getPromos(
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          );

          expect(result, Right<AppFailure, List<PromoEntity>>(promoModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIBerandaRemoteDataSource.getPromos(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          )).thenThrow(SessionException());

          final result = await berandaRepository.getPromos(
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
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
          when(mockIBerandaRemoteDataSource.getPromos(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await berandaRepository.getPromos(
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
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
          when(mockIBerandaRemoteDataSource.getPromos(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          )).thenThrow(ServerException(false));

          final result = await berandaRepository.getPromos(
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
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
          when(mockIBerandaRemoteDataSource.getPromos(
            accessToken: accessToken,
            refreshToken: refreshToken,
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          )).thenThrow(UnknownException('unknown'));

          final result = await berandaRepository.getPromos(
            limit: 10,
            page: 1,
            orderBy: 'orderBy',
            sortBy: 'sortBy',
            keyword: 'keyword',
            isActive: 1,
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
