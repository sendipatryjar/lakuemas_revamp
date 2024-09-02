import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/account_balance/data/data_sources/interfaces/i_account_balance_remote_data_source.dart';
import 'package:lakuemas/features/account_balance/data/models/account_balance_faq_model.dart';
import 'package:lakuemas/features/account_balance/data/models/bank_me_model.dart';
import 'package:lakuemas/features/account_balance/data/models/mutation_model.dart';
import 'package:lakuemas/features/account_balance/data/models/withdrawal_model.dart';
import 'package:lakuemas/features/account_balance/data/repositories/account_balance_repository.dart';
import 'package:lakuemas/features/account_balance/domain/entities/mutation_entity.dart';
import 'package:lakuemas/features/account_balance/domain/entities/withdrawal_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_balance_repository_uc.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  IAccountBalanceRemoteDataSource,
])
void main() {
  late MockIAccountBalanceRemoteDataSource mockIAccountBalanceRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late AccountBalanceRepository accountBalanceRepository;

  setUpAll(() {
    mockIAccountBalanceRemoteDataSource = MockIAccountBalanceRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    accountBalanceRepository = AccountBalanceRepository(
      remoteDataSource: mockIAccountBalanceRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('account balance repository', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';

    group('get balances', () {
      late List<MutationModel> valueData;

      setUp(
        () {
          valueData = [
            MutationModel.fromJson(const {
              'status': 1,
              'customer_id': 1,
              'wallet_id': 1,
              'transaction_id': 1,
              'code': 'code',
              'type': 'type',
              'mutation_type': 'mutationType',
              'amount': 'amount',
              'balance': 'balance',
              'transaction_date': 'transactionDate',
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
          when(mockIAccountBalanceRemoteDataSource.getMutations(
            accessToken: accessToken,
            refreshToken: refreshToken,
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          )).thenAnswer((realInvocation) async => BaseListResp<MutationModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await accountBalanceRepository.getMutations(
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          );

          expect(result, Right<AppFailure, List<MutationEntity>>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIAccountBalanceRemoteDataSource.getMutations(
            accessToken: accessToken,
            refreshToken: refreshToken,
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          )).thenThrow(SessionException());

          final result = await accountBalanceRepository.getMutations(
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
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
          when(mockIAccountBalanceRemoteDataSource.getMutations(
            accessToken: accessToken,
            refreshToken: refreshToken,
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await accountBalanceRepository.getMutations(
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
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
          when(mockIAccountBalanceRemoteDataSource.getMutations(
            accessToken: accessToken,
            refreshToken: refreshToken,
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          )).thenThrow(ServerException(false));

          final result = await accountBalanceRepository.getMutations(
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
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
          when(mockIAccountBalanceRemoteDataSource.getMutations(
            accessToken: accessToken,
            refreshToken: refreshToken,
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          )).thenThrow(UnknownException('unknown'));

          final result = await accountBalanceRepository.getMutations(
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          );

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get faq', () {
      late List<AccountBalanceFaqModel> valueData;
      setUp(
        () {
          valueData = [
            AccountBalanceFaqModel.fromJson(const {
              "question": "Apa itu Saldo Akun Lakuemas?",
              "answer":
                  "Laku Simpan merupakan salah satu layanan Lakuemas dimana kamu mempercayakan emas kamu kepada Lakuemas dalam jangka waktu yang disepakati dengan mendapatkan imbal hasil berupa sewa modal tetap dalam wujud gramasi emas."
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
          when(mockIAccountBalanceRemoteDataSource.getFaq(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer(
              (realInvocation) async => BaseListResp<AccountBalanceFaqModel>(
                    code: 200,
                    msgKey: 'SUCCESS',
                    message: 'SUCCESS',
                    data: valueData,
                  ));

          final result = await accountBalanceRepository.getFaq();

          expect(result,
              Right<AppFailure, List<AccountBalanceFaqModel>>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIAccountBalanceRemoteDataSource.getFaq(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await accountBalanceRepository.getFaq();

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
          when(mockIAccountBalanceRemoteDataSource.getFaq(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await accountBalanceRepository.getFaq();

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
          when(mockIAccountBalanceRemoteDataSource.getFaq(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await accountBalanceRepository.getFaq();

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
          when(mockIAccountBalanceRemoteDataSource.getFaq(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await accountBalanceRepository.getFaq();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get price', () {
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
          when(mockIAccountBalanceRemoteDataSource.getPrice(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseResp<PriceModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await accountBalanceRepository.getPrice();

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
          when(mockIAccountBalanceRemoteDataSource.getPrice(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await accountBalanceRepository.getPrice();

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
          when(mockIAccountBalanceRemoteDataSource.getPrice(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await accountBalanceRepository.getPrice();

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
          when(mockIAccountBalanceRemoteDataSource.getPrice(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await accountBalanceRepository.getPrice();

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
          when(mockIAccountBalanceRemoteDataSource.getPrice(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await accountBalanceRepository.getPrice();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    ///
    ///

    group('get bank me', () {
      late BankMeModel bankMeModel;
      setUp(
        () {
          bankMeModel = const BankMeModel(
            id: 1,
            customerId: 1,
            name: 'name',
            accountName: 'accountName',
            accountNumber: 'accountNumber',
            logo: 'logo',
            serviceFee: '500',
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
          when(mockIAccountBalanceRemoteDataSource.getBankMe(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenAnswer((realInvocation) async => BaseResp<BankMeModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: bankMeModel,
              ));

          final result = await accountBalanceRepository.getBankMe();

          expect(result, Right<AppFailure, BankMeModel>(bankMeModel));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIAccountBalanceRemoteDataSource.getBankMe(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(SessionException());

          final result = await accountBalanceRepository.getBankMe();

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
          when(mockIAccountBalanceRemoteDataSource.getBankMe(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await accountBalanceRepository.getBankMe();

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
          when(mockIAccountBalanceRemoteDataSource.getBankMe(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(ServerException(false));

          final result = await accountBalanceRepository.getBankMe();

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
          when(mockIAccountBalanceRemoteDataSource.getBankMe(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )).thenThrow(UnknownException('unknown'));

          final result = await accountBalanceRepository.getBankMe();

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('withdraw', () {
      late WithdrawalModel valueData;

      setUp(
        () {
          valueData = WithdrawalModel.fromJson(const {
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
          when(mockIAccountBalanceRemoteDataSource.withdraw(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: 10,
          )).thenAnswer((realInvocation) async => BaseResp<WithdrawalModel>(
                code: 200,
                msgKey: 'SUCCESS',
                message: 'SUCCESS',
                data: valueData,
              ));

          final result = await accountBalanceRepository.withdraw(amount: 10);

          expect(result, Right<AppFailure, WithdrawalEntity>(valueData));
        },
      );

      test(
        'SessionException 401',
        () async {
          when(mockITokenLocalDataSource.getAccessToken())
              .thenAnswer((realInvocation) async => accessToken);
          when(mockITokenLocalDataSource.getRefreshToken())
              .thenAnswer((realInvocation) async => refreshToken);
          when(mockIAccountBalanceRemoteDataSource.withdraw(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: 10,
          )).thenThrow(SessionException());

          final result = await accountBalanceRepository.withdraw(amount: 10);

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
          when(mockIAccountBalanceRemoteDataSource.withdraw(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: 10,
          )).thenThrow(
              ClientException(400, 'The request parameter invalid', null));

          final result = await accountBalanceRepository.withdraw(amount: 10);

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
          when(mockIAccountBalanceRemoteDataSource.withdraw(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: 10,
          )).thenThrow(ServerException(false));

          final result = await accountBalanceRepository.withdraw(amount: 10);

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
          when(mockIAccountBalanceRemoteDataSource.withdraw(
            accessToken: accessToken,
            refreshToken: refreshToken,
            amount: 10,
          )).thenThrow(UnknownException('unknown'));

          final result = await accountBalanceRepository.withdraw(amount: 10);

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
