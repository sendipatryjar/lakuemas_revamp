import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/redeem/data/data_sources/interfaces/i_voucher_redeem_remote_data_source.dart';
import 'package:lakuemas/features/redeem/data/models/voucher_redeem_model.dart';
import 'package:lakuemas/features/redeem/data/models/voucher_redeemed_model.dart';
import 'package:lakuemas/features/redeem/data/repositories/voucher_redeem_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_redeem_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  IVoucherRedeemRemoteDataSource,
])
void main() {
  late MockIVoucherRedeemRemoteDataSource mockIVoucherRedeemRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late VoucherRedeemRepository voucherRedeemRepository;

  setUpAll(() {
    mockIVoucherRedeemRemoteDataSource = MockIVoucherRedeemRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    voucherRedeemRepository = VoucherRedeemRepository(
      remoteDataSource: mockIVoucherRedeemRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('buy gold repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('check', () {
      late VoucherRedeemModel valueData;

      setUp(
        () {
          valueData = VoucherRedeemModel.fromJson(const {
            'name': 'name',
            'code': 'code',
            'amount': '100025',
            'gold_amount': '5.0',
            'selling_price': '970000',
            'purchase_price': '980000',
            'tax': '0',
            'gold_redeemed': '5.0',
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
          when(mockIVoucherRedeemRemoteDataSource.check(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
          )).thenAnswer((realInvocation) async => BaseResp<VoucherRedeemModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result =
              await voucherRedeemRepository.check(voucherCode: 'voucherCode');

          expect(result, Right<AppFailure, VoucherRedeemModel>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIVoucherRedeemRemoteDataSource.check(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
          )).thenThrow(SessionException());

          final result =
              await voucherRedeemRepository.check(voucherCode: 'voucherCode');

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
          when(mockIVoucherRedeemRemoteDataSource.check(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result =
              await voucherRedeemRepository.check(voucherCode: 'voucherCode');

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
          when(mockIVoucherRedeemRemoteDataSource.check(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
          )).thenThrow(ServerException(false));

          final result =
              await voucherRedeemRepository.check(voucherCode: 'voucherCode');

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
          when(mockIVoucherRedeemRemoteDataSource.check(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
          )).thenThrow(UnknownException('unknown'));

          final result =
              await voucherRedeemRepository.check(voucherCode: 'voucherCode');

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('redeem', () {
      late VoucherRedeemedModel voucherRedeemedModel;
      setUp(
        () {
          voucherRedeemedModel = const VoucherRedeemedModel(
            transactionId: 1,
            transactionCode: 'transactionCode',
            goldRedeemed: '5.0',
            status: 1,
            statusLabel: 'statusLabel',
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
          when(mockIVoucherRedeemRemoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          )).thenAnswer(
              (realInvocation) async => BaseResp<VoucherRedeemedModel>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: voucherRedeemedModel,
                  ));

          final result = await voucherRedeemRepository.redeem(
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          );

          expect(result,
              Right<AppFailure, VoucherRedeemedModel>(voucherRedeemedModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIVoucherRedeemRemoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          )).thenThrow(SessionException());

          final result = await voucherRedeemRepository.redeem(
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
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
          when(mockIVoucherRedeemRemoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await voucherRedeemRepository.redeem(
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
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
          when(mockIVoucherRedeemRemoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          )).thenThrow(ServerException(false));

          final result = await voucherRedeemRepository.redeem(
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
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
          when(mockIVoucherRedeemRemoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          )).thenThrow(UnknownException('unknown'));

          final result = await voucherRedeemRepository.redeem(
            voucherCode: 'voucherCode',
            goldRedeemed: 5.0,
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
