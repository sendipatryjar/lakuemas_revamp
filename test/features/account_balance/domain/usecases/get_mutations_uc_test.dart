import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/account_balance/domain/entities/mutation_entity.dart';
import 'package:lakuemas/features/account_balance/domain/usecases/get_mutations_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_bank_me_uc_test.mocks.dart';

void main() {
  late MockIAccountBalanceRepository mockIAccountBalanceRepository;
  late GetMutationsUc getMutationsUc;
  late List<MutationEntity> mutations;

  setUpAll(() {
    mockIAccountBalanceRepository = MockIAccountBalanceRepository();
    getMutationsUc = GetMutationsUc(repository: mockIAccountBalanceRepository);
    mutations = const [
      MutationEntity(
        status: 1,
        walletId: 1,
        customerId: 1,
        transactionId: 1,
        code: 'code',
        type: 'type',
        mutationType: 'mutationType',
        amount: '250000',
        balance: '400000',
        transactionDate: '7 Sep 2023',
      ),
    ];
  });

  group('Get Mutations Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAccountBalanceRepository.getMutations())
            .thenAnswer((realInvocation) async => Right(mutations));

        final result = await getMutationsUc();

        expect(result, Right(mutations));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAccountBalanceRepository.getMutations())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getMutationsUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAccountBalanceRepository.getMutations()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getMutationsUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAccountBalanceRepository.getMutations())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getMutationsUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAccountBalanceRepository.getMutations())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getMutationsUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
