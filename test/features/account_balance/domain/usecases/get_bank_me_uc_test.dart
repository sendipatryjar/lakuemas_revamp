import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/account_balance/domain/entities/bank_me_entity.dart';
import 'package:lakuemas/features/account_balance/domain/repositories/i_account_balance_repository.dart';
import 'package:lakuemas/features/account_balance/domain/usecases/get_bank_me_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_bank_me_uc_test.mocks.dart';

@GenerateMocks([IAccountBalanceRepository])
void main() {
  late MockIAccountBalanceRepository mockIAccountBalanceRepository;
  late GetBankMeUc getBankMeUc;
  late BankMeEntity bankMeEntity;

  setUpAll(() {
    mockIAccountBalanceRepository = MockIAccountBalanceRepository();
    getBankMeUc = GetBankMeUc(repository: mockIAccountBalanceRepository);
    bankMeEntity = const BankMeEntity(
      id: 1,
      customerId: 1,
      name: 'name',
      accountName: 'accountName',
      accountNumber: '123456789',
      logo: 'logo',
      serviceFee: '500',
    );
  });

  group('Get Bank Me Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAccountBalanceRepository.getBankMe())
            .thenAnswer((realInvocation) async => Right(bankMeEntity));

        final result = await getBankMeUc();

        expect(result, Right(bankMeEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAccountBalanceRepository.getBankMe())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getBankMeUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAccountBalanceRepository.getBankMe()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getBankMeUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAccountBalanceRepository.getBankMe())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getBankMeUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAccountBalanceRepository.getBankMe())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getBankMeUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
