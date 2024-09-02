import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/_core/transaction/data/models/checkout_model.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/_core/user/data/models/balance_model.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/sell_gold/data/data_sources/interfaces/i_sell_gold_remote_data_source.dart';
import 'package:lakuemas/features/sell_gold/data/repositories/sell_gold_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sell_gold_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  ISellGoldRemoteDataSource,
])
void main() {
  late MockISellGoldRemoteDataSource mockISellGoldRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late SellGoldRepository sellGoldRepository;

  setUpAll(() {
    mockISellGoldRemoteDataSource = MockISellGoldRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    sellGoldRepository = SellGoldRepository(
      remoteDataSource: mockISellGoldRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('Sell gold repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('checkout', () {
      late CheckoutModel valueData;
      late double amount;
      late String amountType;

      setUp(
        () {
          valueData = CheckoutModel.fromJson(const {
            'amount': '100025',
            'gold_amount': '0.2',
            'purchase_price': '100000',
            'gross_amount': '100025',
            'nominal_tax': '0',
            'percentage_tax': '0',
            'transaction_key': 'qwertasdfgzxcvb',
          });
          amount = 100025;
          amountType = 'nominal';
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockISellGoldRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: amount,
            amountType: amountType,
          )).thenAnswer((realInvocation) async => BaseResp<CheckoutModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await sellGoldRepository.checkout(
            amount: amount,
            amountType: amountType,
          );

          expect(result, Right<AppFailure, CheckoutEntity>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockISellGoldRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: amount,
            amountType: amountType,
          )).thenThrow(SessionException());

          final result = await sellGoldRepository.checkout(
            amount: amount,
            amountType: amountType,
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
          when(mockISellGoldRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: amount,
            amountType: amountType,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await sellGoldRepository.checkout(
            amount: amount,
            amountType: amountType,
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
          when(mockISellGoldRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: amount,
            amountType: amountType,
          )).thenThrow(ServerException(false));

          final result = await sellGoldRepository.checkout(
            amount: amount,
            amountType: amountType,
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
          when(mockISellGoldRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: amount,
            amountType: amountType,
          )).thenThrow(UnknownException('unknown'));

          final result = await sellGoldRepository.checkout(
            amount: amount,
            amountType: amountType,
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

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
          when(mockISellGoldRemoteDataSource.getBalances(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenAnswer((realInvocation) async => BaseListResp<BalanceModel>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: valueData,
                  ));

          final result = await sellGoldRepository.getBalances();

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
          when(mockISellGoldRemoteDataSource.getBalances(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(SessionException());

          final result = await sellGoldRepository.getBalances();

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
          when(mockISellGoldRemoteDataSource.getBalances(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(
                  ClientException(400, 'The request parameter invalid', null));

          final result = await sellGoldRepository.getBalances();

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
          when(mockISellGoldRemoteDataSource.getBalances(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(ServerException(false));

          final result = await sellGoldRepository.getBalances();

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
          when(mockISellGoldRemoteDataSource.getBalances(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(UnknownException('unknown'));

          final result = await sellGoldRepository.getBalances();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('get prices', () {
      late PriceModel priceModel;
      setUp(
        () {
          priceModel = const PriceModel(
            price: '990000',
            sellingPrice: '990000',
            eliteSellingPrice: '990000',
            purchasePrice: '990000',
            elitePurchasePrice: '990000',
            taxPercentage: '3',
            taxNominal: '3000',
            minimumNominal: '50000',
            minimumGrammation: '0.05',
            placeholderNominal: ['100000', '200000'],
            placeholderGrammation: ['1.00', '2.00'],
          );
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockISellGoldRemoteDataSource.getPrice(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenAnswer((realInvocation) async => BaseResp<PriceModel>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: priceModel,
                  ));

          final result = await sellGoldRepository.getPrice();

          expect(result, Right<AppFailure, PriceEntity>(priceModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockISellGoldRemoteDataSource.getPrice(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(SessionException());

          final result = await sellGoldRepository.getPrice();

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
          when(mockISellGoldRemoteDataSource.getPrice(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(
                  ClientException(400, 'The request parameter invalid', null));

          final result = await sellGoldRepository.getPrice();

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
          when(mockISellGoldRemoteDataSource.getPrice(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(ServerException(false));

          final result = await sellGoldRepository.getPrice();

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
          when(mockISellGoldRemoteDataSource.getPrice(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(UnknownException('unknown'));

          final result = await sellGoldRepository.getPrice();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
