import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/transfer/data/data_sources/interfaces/i_transfer_local_data_source.dart';
import 'package:lakuemas/features/transfer/data/data_sources/interfaces/i_transfer_remote_data_source.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_charge_model.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_checkout_model.dart';
import 'package:lakuemas/features/transfer/data/repositories/transfer_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transfer_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  ITransferRemoteDataSource,
  ITransferLocalDataSource,
])
void main() {
  late MockITransferRemoteDataSource mockITransferRemoteDataSource;
  late MockITransferLocalDataSource mockITransferLocalDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late TransferRepository transferRepository;

  setUpAll(() {
    mockITransferRemoteDataSource = MockITransferRemoteDataSource();
    mockITransferLocalDataSource = MockITransferLocalDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    transferRepository = TransferRepository(
      remoteDataSource: mockITransferRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
      localDataSource: mockITransferLocalDataSource,
    );
  });

  group('buy gold repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('transfer charge', () {
      late TransferChargeModel valueData;

      setUp(
        () {
          valueData = TransferChargeModel.fromJson(const {
            'account_name': 'accountName',
            'account_number': '1234567890',
            'gold_weight': '2.0',
            'transaction_key': 'transactionKey',
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
          when(mockITransferRemoteDataSource.transferCharge(
            accessToken: accessToken,
            refreshToken: refreshToken,
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
          )).thenAnswer((realInvocation) async => BaseResp<TransferChargeModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await transferRepository.transferCharge(
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
          );

          expect(result, Right<AppFailure, TransferChargeModel>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockITransferRemoteDataSource.transferCharge(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  accountNumber: 'accountNumber',
                  goldWeight: 2.0,
                  isAddFavorite: false,
                  note: '-'))
              .thenThrow(SessionException());

          final result = await transferRepository.transferCharge(
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
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
          when(mockITransferRemoteDataSource.transferCharge(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  accountNumber: 'accountNumber',
                  goldWeight: 2.0,
                  isAddFavorite: false,
                  note: '-'))
              .thenThrow(
                  ClientException(400, 'The request parameter invalid', null));

          final result = await transferRepository.transferCharge(
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
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
          when(mockITransferRemoteDataSource.transferCharge(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  accountNumber: 'accountNumber',
                  goldWeight: 2.0,
                  isAddFavorite: false,
                  note: '-'))
              .thenThrow(ServerException(false));

          final result = await transferRepository.transferCharge(
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
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
          when(mockITransferRemoteDataSource.transferCharge(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  accountNumber: 'accountNumber',
                  goldWeight: 2.0,
                  isAddFavorite: false,
                  note: '-'))
              .thenThrow(UnknownException('unknown'));

          final result = await transferRepository.transferCharge(
            accountNumber: 'accountNumber',
            goldWeight: 2.0,
            isAddFavorite: false,
            note: '-',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('transfer checkout', () {
      late TransferCheckoutModel valueData;
      setUp(
        () {
          valueData = TransferCheckoutModel.fromJson(const {
            'transaction_code': 'transactionCode',
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
          when(mockITransferRemoteDataSource.transferCheckout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionKey: 'transactionKey',
          )).thenAnswer(
              (realInvocation) async => BaseResp<TransferCheckoutModel>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: valueData,
                  ));

          final result = await transferRepository.transferCheckout(
              transactionKey: 'transactionKey');

          expect(result, Right<AppFailure, TransferCheckoutModel>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockITransferRemoteDataSource.transferCheckout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionKey: 'transactionKey',
          )).thenThrow(SessionException());

          final result = await transferRepository.transferCheckout(
              transactionKey: 'transactionKey');

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
          when(mockITransferRemoteDataSource.transferCheckout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionKey: 'transactionKey',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await transferRepository.transferCheckout(
              transactionKey: 'transactionKey');

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
          when(mockITransferRemoteDataSource.transferCheckout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionKey: 'transactionKey',
          )).thenThrow(ServerException(false));

          final result = await transferRepository.transferCheckout(
              transactionKey: 'transactionKey');

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
          when(mockITransferRemoteDataSource.transferCheckout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionKey: 'transactionKey',
          )).thenThrow(UnknownException('unknown'));

          final result = await transferRepository.transferCheckout(
              transactionKey: 'transactionKey');

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
