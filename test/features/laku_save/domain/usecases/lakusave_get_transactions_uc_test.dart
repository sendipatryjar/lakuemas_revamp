import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/laku_save/domain/entities/deposit_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/transaction_entity.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/lakusave_get_transactions_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_about_uc_test.mocks.dart';

void main() {
  late MockILakusaveRepository mockILakusaveRepository;
  late LakusaveGetTransactionsUc lakusaveGetTransactionsUc;
  late List<TransactionEntity> res;

  setUpAll(() {
    mockILakusaveRepository = MockILakusaveRepository();
    lakusaveGetTransactionsUc =
        LakusaveGetTransactionsUc(repository: mockILakusaveRepository);
    DepositEntity depositEntity = const DepositEntity(
      accountNumber: '123456789',
      duration: '4',
      durationType: 'month',
      extendLabel: 'extendLabel',
      interest: 'interest',
      isEnableUpdateExtend: false,
      startDate: '12 Januari 2023',
      endDate: '12 Mei 2023',
    );
    res = [
      TransactionEntity(
        id: 1,
        code: 'code',
        goldWeight: '2.0',
        depositEntity: depositEntity,
        typeLabel: 'typeLabel',
        status: 1,
        statusLabel: 'statusLabel',
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
    ];
  });

  group('Lakusave Get Transactions Usecase', () {
    GetTransactionsParams params = GetTransactionsParams(
      type: 'deposit',
      page: 1,
      limit: 1000,
      orderBy: 'created_at',
      sortBy: 'desc',
      status: 1,
    );

    test(
      'Success',
      () async {
        when(mockILakusaveRepository.getTransactions(request: params))
            .thenAnswer((realInvocation) async => Right(res));

        final result = await lakusaveGetTransactionsUc(params: params);

        expect(result, Right(res));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILakusaveRepository.getTransactions(request: params))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await lakusaveGetTransactionsUc(params: params);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILakusaveRepository.getTransactions(request: params))
            .thenAnswer((realInvocation) async =>
                const Left(MobileValidationFailure()));

        final result = await lakusaveGetTransactionsUc(params: params);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILakusaveRepository.getTransactions(request: params))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await lakusaveGetTransactionsUc(params: params);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILakusaveRepository.getTransactions(request: params))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await lakusaveGetTransactionsUc(params: params);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
