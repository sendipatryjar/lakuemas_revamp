import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/cubits/helper_data/helper_data_cubit.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/get_balances_uc.dart';
import 'package:lakuemas/features/buy_gold/presentation/blocs/balance/bgold_balance_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bgold_balance_bloc_test.mocks.dart';

@GenerateMocks([GetBalancesUc])
void main() {
  late MockGetBalancesUc mockGetBalancesUc;
  late BgoldBalanceBloc bgoldBalanceBloc;
  late HelperDataCubit helperDataCubit;

  setUp(() {
    mockGetBalancesUc = MockGetBalancesUc();
    bgoldBalanceBloc = BgoldBalanceBloc(getBalancesUc: mockGetBalancesUc);
    helperDataCubit = HelperDataCubit();
  });

  group('Success Get Balance bGold', () {
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
    final event = BgoldGetBalanceEvent(helperDataCubit: helperDataCubit);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockGetBalancesUc.call())
            .thenAnswer((realInvocation) async => Right(listBalance));

        return bgoldBalanceBloc;
      },
      expectedStates: [
        BgoldBalanceLoadingState(),
        const BgoldBalanceSuccessState(balanceEntity: bEntity),
      ],
      verifyCall: () => verify(mockGetBalancesUc.call()),
    );
  });

  group('Error get Balance', () {
    final event = BgoldGetBalanceEvent(helperDataCubit: helperDataCubit);
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

          return bgoldBalanceBloc;
        },
        expectedStates: [
          BgoldBalanceLoadingState(),
          if (failureType is SessionFailure)
            BgoldBalanceFailureState(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const BgoldBalanceFailureState(
                MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const BgoldBalanceFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            BgoldBalanceFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockGetBalancesUc.call()),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required BgoldBalanceBloc Function() build,
  required List<BgoldBalanceState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<BgoldBalanceBloc, BgoldBalanceState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
