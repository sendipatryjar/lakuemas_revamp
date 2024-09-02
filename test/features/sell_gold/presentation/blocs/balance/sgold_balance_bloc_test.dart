import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/cubits/helper_data/helper_data_cubit.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/sell_gold/presentation/blocs/balance/sgold_balance_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/get_balances_uc.dart';
import 'package:mockito/mockito.dart';

import 'sgold_balance_bloc_test.mocks.dart';

@GenerateMocks([GetBalancesUc])
void main() {
  late MockGetBalancesUc mockGetBalancesUc;
  late SgoldBalanceBloc sgoldBalanceBloc;
  late HelperDataCubit helperDataCubit;

  setUp(() {
    mockGetBalancesUc = MockGetBalancesUc();
    sgoldBalanceBloc = SgoldBalanceBloc(getBalancesUc: mockGetBalancesUc);
    helperDataCubit = HelperDataCubit();
  });

  group('Success get Balance sell gold', () {
    const bEntity = BalanceEntity(
      customerId: 1,
      paymentMethodId: 24,
      transactionStatus: 1,
      nominalBalance: 10000,
      gramationBalance: '1.0',
      accountNumber: '111111',
      transactionCode: 'PRE111111111',
      type: 'gold_balance',
    );

    final listBalance = [bEntity];
    final event = SgoldGetBalanceEvent(helperDataCubit: helperDataCubit);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockGetBalancesUc.call())
            .thenAnswer((realInvocation) async => Right(listBalance));

        return sgoldBalanceBloc;
      },
      expectedStates: [
        SgoldBalanceLoadingState(),
        const SgoldBalanceSuccessState(balanceEntity: bEntity),
      ],
      verifyCall: () => verify(mockGetBalancesUc.call()),
    );
  });

  group('Error get Balance', () {
    final event = SgoldGetBalanceEvent(helperDataCubit: helperDataCubit);
    final failureTypes = [
      SessionFailure(),
      const MobileValidationFailure(),
      const ServerFailure(),
      UnknownFailure(),
    ];

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockGetBalancesUc.call())
              .thenAnswer((realInvocation) async => Left(failureType));

          return sgoldBalanceBloc;
        },
        expectedStates: [
          SgoldBalanceLoadingState(),
          if (failureType is SessionFailure)
            SgoldBalanceFailureState(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const SgoldBalanceFailureState(
                MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const SgoldBalanceFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            SgoldBalanceFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockGetBalancesUc.call()),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required SgoldBalanceBloc Function() build,
  required List<SgoldBalanceState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<SgoldBalanceBloc, SgoldBalanceState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
