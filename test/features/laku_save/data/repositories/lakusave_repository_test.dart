import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/laku_save/data/data_sources/interfaces/i_lakusave_remote_data_source.dart';
import 'package:lakuemas/features/laku_save/data/models/gold_deposit_model.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_checkout_req.dart';
import 'package:lakuemas/features/laku_save/data/models/transaction_model.dart';
import 'package:lakuemas/features/laku_save/data/repositories/lakusave_repository.dart';
import 'package:lakuemas/features/laku_save/domain/entities/transaction_entity.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/lakusave_get_transactions_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lakusave_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  ILakusaveRemoteDataSource,
])
void main() {
  late MockILakusaveRemoteDataSource mockILakusaveRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late LakusaveRepository lakusaveRepository;

  setUpAll(() {
    mockILakusaveRemoteDataSource = MockILakusaveRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    lakusaveRepository = LakusaveRepository(
      remoteDataSource: mockILakusaveRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('lakusave repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';
    LakusaveCheckoutReq req = LakusaveCheckoutReq(
      durationId: 1,
      extendedId: 1,
      goldWeight: 2.0,
      accountNumber: '123456789',
      accountNumberDest: '987654321',
    );

    group('get master data lakusave', () {
      late GoldDepositModel goldDepositModel;
      setUp(() {
        final jsonData = {
          'minimum_balance': '10',
          'elite_minimum_balance': '1',
          'term_and_conditions': {
            'title': 'title',
            'description': 'description',
          },
          'durations': [
            {
              'id': 1,
              'type': 'type',
              'duration': 4,
            },
          ],
          'extends': [
            {
              'id': 1,
              'name': 'name',
              'description': 'description',
            },
          ],
          'interests': [
            {
              'id': 1,
              'deposit_duraton_id': 1,
              'customer_type_id': 1,
              'interest': 3.0,
              'tax': 0.0,
              'minimum_balance': 10.0,
              'elite_minimum_balance': 1.0,
              'maximum_balance': 100.0,
              'created_at': 'createdAt',
              'updated_at': 'updatedAt',
            },
          ],
        };

        goldDepositModel = GoldDepositModel.fromJson(jsonData);
      });
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.getMasterDataLakusave(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseResp<GoldDepositModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: goldDepositModel,
              ));

          final result = await lakusaveRepository.getMasterData();

          expect(result, Right<AppFailure, GoldDepositModel>(goldDepositModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.getMasterDataLakusave(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await lakusaveRepository.getMasterData();

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
          when(mockILakusaveRemoteDataSource.getMasterDataLakusave(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await lakusaveRepository.getMasterData();

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
          when(mockILakusaveRemoteDataSource.getMasterDataLakusave(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await lakusaveRepository.getMasterData();

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
          when(mockILakusaveRemoteDataSource.getMasterDataLakusave(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await lakusaveRepository.getMasterData();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('checkout', () {
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: req,
          )).thenAnswer((realInvocation) async => BaseResp<dynamic>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: {
                  "transaction_id": 1,
                  "status": 3,
                  "status_label": "Menunggu Disetujui",
                  "transaction_code": "AD2100032",
                  "gold_weight": "1",
                  "interest": "3",
                  "duration": "3",
                  "duration_type": "daily",
                  "extend_type": "Tidak diperpanjang",
                  "start_date": "2023-07-06",
                  "end_date": "2023-11-06"
                },
              ));

          final result = await lakusaveRepository.checkout(
            request: req,
          );

          expect(result, const Right<AppFailure, bool>(true));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: req,
          )).thenThrow(SessionException());

          final result = await lakusaveRepository.checkout(request: req);

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
          when(mockILakusaveRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: req,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await lakusaveRepository.checkout(request: req);

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
          when(mockILakusaveRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: req,
          )).thenThrow(ServerException(false));

          final result = await lakusaveRepository.checkout(request: req);

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
          when(mockILakusaveRemoteDataSource.checkout(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: req,
          )).thenThrow(UnknownException('unknown'));

          final result = await lakusaveRepository.checkout(request: req);

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('cancel', () {
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.cancel(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionCode: '123123',
          )).thenAnswer((realInvocation) async => BaseResp<dynamic>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
              ));

          final result =
              await lakusaveRepository.cancel(transactionCode: '123123');

          expect(result, const Right<AppFailure, bool>(true));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.cancel(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionCode: '123123',
          )).thenThrow(SessionException());

          final result =
              await lakusaveRepository.cancel(transactionCode: '123123');

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
          when(mockILakusaveRemoteDataSource.cancel(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionCode: '123123',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result =
              await lakusaveRepository.cancel(transactionCode: '123123');

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
          when(mockILakusaveRemoteDataSource.cancel(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionCode: '123123',
          )).thenThrow(ServerException(false));

          final result =
              await lakusaveRepository.cancel(transactionCode: '123123');

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
          when(mockILakusaveRemoteDataSource.cancel(
            accessToken: accessToken,
            refreshToken: refreshToken,
            transactionCode: '123123',
          )).thenThrow(UnknownException('unknown'));

          final result =
              await lakusaveRepository.cancel(transactionCode: '123123');

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get transactions', () {
      late GetTransactionsParams request;
      late List<TransactionModel> valueData;
      setUp(
        () {
          request = GetTransactionsParams(
            limit: 10,
            page: 1,
            type: 'type',
            status: 1,
            orderBy: 'DESC',
            sortBy: 'created_at',
          );
          valueData = [
            TransactionModel.fromJson(const {
              'id': 1,
              'status': 1,
              'gold_weight': '5.0',
              'type_label': 'typeLabel',
              'status_label': 'statusLabel',
              'code': 'code',
              'created_at': 'createdAt',
              'updated_at': 'updatedAt',
              'deposit': {
                'is_enable_update_extend': null,
                'account_number': '123456789',
                'interest': 'interest',
                'duration': 'duration',
                'duration_type': 'durationType',
                'extend_label': 'extendLabel',
                'start_date': 'startDate',
                'end_date': 'endDate',
              },
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
          when(
            mockILakusaveRemoteDataSource.getTransactions(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: request,
            ),
          ).thenAnswer((realInvocation) async => BaseListResp<TransactionModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result =
              await lakusaveRepository.getTransactions(request: request);

          expect(result, Right<AppFailure, List<TransactionEntity>>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(
            mockILakusaveRemoteDataSource.getTransactions(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: request,
            ),
          ).thenThrow(SessionException());

          final result =
              await lakusaveRepository.getTransactions(request: request);

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
          when(
            mockILakusaveRemoteDataSource.getTransactions(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: request,
            ),
          ).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result =
              await lakusaveRepository.getTransactions(request: request);

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
          when(
            mockILakusaveRemoteDataSource.getTransactions(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: request,
            ),
          ).thenThrow(ServerException(false));

          final result =
              await lakusaveRepository.getTransactions(request: request);

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
          when(
            mockILakusaveRemoteDataSource.getTransactions(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: request,
            ),
          ).thenThrow(UnknownException('unknown'));

          final result =
              await lakusaveRepository.getTransactions(request: request);

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('update extend', () {
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.updateExtend(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  extendId: 1,
                  accountNumber: '123456789'))
              .thenAnswer((realInvocation) async => BaseResp<dynamic>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: null,
                  ));

          final result = await lakusaveRepository.updateExtend(
            extendId: 1,
            accountNumber: '123456789',
          );

          expect(result, const Right<AppFailure, bool>(true));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.updateExtend(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  extendId: 1,
                  accountNumber: '123456789'))
              .thenThrow(SessionException());

          final result = await lakusaveRepository.updateExtend(
            extendId: 1,
            accountNumber: '123456789',
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
          when(mockILakusaveRemoteDataSource.updateExtend(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  extendId: 1,
                  accountNumber: '123456789'))
              .thenThrow(
                  ClientException(400, 'The request parameter invalid', null));

          final result = await lakusaveRepository.updateExtend(
            extendId: 1,
            accountNumber: '123456789',
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
          when(mockILakusaveRemoteDataSource.updateExtend(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  extendId: 1,
                  accountNumber: '123456789'))
              .thenThrow(ServerException(false));

          final result = await lakusaveRepository.updateExtend(
            extendId: 1,
            accountNumber: '123456789',
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
          when(mockILakusaveRemoteDataSource.updateExtend(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  extendId: 1,
                  accountNumber: '123456789'))
              .thenThrow(UnknownException('unknown'));

          final result = await lakusaveRepository.updateExtend(
            extendId: 1,
            accountNumber: '123456789',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get about', () {
      late String resResp;
      setUp(
        () {
          resResp = 'get about resp';
        },
      );
      test(
        'success 200',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.getAbout(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenAnswer((realInvocation) async => resResp);

          final result = await lakusaveRepository.getAbout();

          expect(result, Right<AppFailure, String?>(resResp));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockILakusaveRemoteDataSource.getAbout(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(SessionException());

          final result = await lakusaveRepository.getAbout();

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
          when(mockILakusaveRemoteDataSource.getAbout(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(
                  ClientException(400, 'The request parameter invalid', null));

          final result = await lakusaveRepository.getAbout();

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
          when(mockILakusaveRemoteDataSource.getAbout(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(ServerException(false));

          final result = await lakusaveRepository.getAbout();

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
          when(mockILakusaveRemoteDataSource.getAbout(
                  accessToken: accessToken, refreshToken: refreshToken))
              .thenThrow(UnknownException('unknown'));

          final result = await lakusaveRepository.getAbout();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
