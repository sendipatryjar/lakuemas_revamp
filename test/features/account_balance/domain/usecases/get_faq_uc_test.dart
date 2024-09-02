import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/account_balance/domain/entities/account_balance_faq_entity.dart';
import 'package:lakuemas/features/account_balance/domain/usecases/get_faq_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_bank_me_uc_test.mocks.dart';

void main() {
  late MockIAccountBalanceRepository mockIAccountBalanceRepository;
  late GetFaqUc getFaqUc;
  late List<AccountBalanceFaqEntity> accountBalanceFaqs;

  setUpAll(() {
    mockIAccountBalanceRepository = MockIAccountBalanceRepository();
    getFaqUc = GetFaqUc(repository: mockIAccountBalanceRepository);
    accountBalanceFaqs = const [
      AccountBalanceFaqEntity(
        question: 'question',
        answer: 'answer',
      ),
    ];
  });

  group('Get Faq Account Balance Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAccountBalanceRepository.getFaq())
            .thenAnswer((realInvocation) async => Right(accountBalanceFaqs));

        final result = await getFaqUc();

        expect(result, Right(accountBalanceFaqs));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAccountBalanceRepository.getFaq())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getFaqUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAccountBalanceRepository.getFaq()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getFaqUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAccountBalanceRepository.getFaq())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getFaqUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAccountBalanceRepository.getFaq())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getFaqUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
