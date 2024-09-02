import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_charge_entity.dart';
import 'package:lakuemas/features/transfer/domain/usecases/transfer_charge_uc.dart';
import 'package:lakuemas/features/transfer/presentation/blocs/transfer_charge/transfer_charge_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transfer_charge_bloc_test.mocks.dart';

@GenerateMocks([TransferChargeUc])
void main() {
  late MockTransferChargeUc mockTransferChargeUc;
  late TransferChargeBloc transferChargeBloc;

  setUp(() {
    mockTransferChargeUc = MockTransferChargeUc();
    transferChargeBloc =
        TransferChargeBloc(transferChargeUc: mockTransferChargeUc);
  });

  group('success transfer charge', () {
    const bool isAddFavorite = true;
    const double goldWeight = 11.0;
    const String accountNumber = '111111';

    const transferChargeEntity = TransferChargeEntity(
      accountName: 'abogoboga',
      accountNumber: '111111',
      goldWeight: '11',
      transactionKey: 'PRE111000',
    );

    const event = TransferChargeNowEvent(
      isAddFavorite: isAddFavorite,
      goldWeight: goldWeight,
      accountNumber: accountNumber,
    );

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockTransferChargeUc.call(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenAnswer(
            (realInvocation) async => const Right(transferChargeEntity));

        return transferChargeBloc;
      },
      expectedStates: [
        TransferChargeLoadingState(),
        const TransferChargeSuccessState(transferChargeEntity),
      ],
      verifyCall: () => verify(mockTransferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )),
    );
  });

  group('error transfer charge', () {
    const bool isAddFavorite = true;
    const double goldWeight = 11.0;
    const String accountNumber = '111111';

    const event = TransferChargeNowEvent(
      isAddFavorite: isAddFavorite,
      goldWeight: goldWeight,
      accountNumber: accountNumber,
    );

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
          when(mockTransferChargeUc.call(
            isAddFavorite: isAddFavorite,
            goldWeight: goldWeight,
            accountNumber: accountNumber,
          )).thenAnswer((realInvocation) async => Left(failureType));

          return transferChargeBloc;
        },
        expectedStates: [
          TransferChargeLoadingState(),
          if (failureType is SessionFailure)
            TransferChargeFailureState(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const TransferChargeFailureState(
                MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const TransferChargeFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            TransferChargeFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockTransferChargeUc.call(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required TransferChargeBloc Function() build,
  required List<TransferChargeState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<TransferChargeBloc, TransferChargeState>(
    'emits [Loading, $description] when TransferChargeNowEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
