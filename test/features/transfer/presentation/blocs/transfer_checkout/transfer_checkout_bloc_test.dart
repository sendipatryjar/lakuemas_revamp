import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_checkout_entity.dart';
import 'package:lakuemas/features/transfer/domain/usecases/transfer_checkout_uc.dart';
import 'package:lakuemas/features/transfer/presentation/blocs/transfer_checkout/transfer_checkout_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transfer_checkout_bloc_test.mocks.dart';

@GenerateMocks([TransferCheckoutUc])
void main() {
  late MockTransferCheckoutUc mockTransferCheckoutUc;
  late TransferCheckoutBloc transferCheckoutBloc;

  setUp(() {
    mockTransferCheckoutUc = MockTransferCheckoutUc();
    transferCheckoutBloc =
        TransferCheckoutBloc(transferCheckoutUc: mockTransferCheckoutUc);
  });

  group('success transfer chekout', () {
    const String trxKey = '111111111';

    const transferCheckoutEntity = TransferCheckoutEntity(
      transactionCode: '1111111111111',
    );

    const event = TransferCheckoutNowEvent(
      transactionKey: trxKey,
    );

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockTransferCheckoutUc.call(
          transactionKey: trxKey,
        )).thenAnswer(
            (realInvocation) async => const Right(transferCheckoutEntity));

        return transferCheckoutBloc;
      },
      expectedStates: [
        TransferCheckoutLoadingState(),
        TransferCheckoutSuccessState(
            transactionCode: transferCheckoutEntity.transactionCode!),
      ],
      verifyCall: () => verify(mockTransferCheckoutUc.call(
        transactionKey: trxKey,
      )),
    );
  });

  group('error transfer checkout', () {
    const String trxKey = '111111111';

    const event = TransferCheckoutNowEvent(
      transactionKey: trxKey,
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
          when(mockTransferCheckoutUc.call(
            transactionKey: trxKey,
          )).thenAnswer((realInvocation) async => Left(failureType));

          return transferCheckoutBloc;
        },
        expectedStates: [
          TransferCheckoutLoadingState(),
          if (failureType is SessionFailure)
            TransferCheckoutFailureState(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const TransferCheckoutFailureState(
                MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const TransferCheckoutFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            TransferCheckoutFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockTransferCheckoutUc.call(
          transactionKey: trxKey,
        )),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required TransferCheckoutBloc Function() build,
  required List<TransferCheckoutState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<TransferCheckoutBloc, TransferCheckoutState>(
    'emits [Loading, $description] when TransferCheckoutNowEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
