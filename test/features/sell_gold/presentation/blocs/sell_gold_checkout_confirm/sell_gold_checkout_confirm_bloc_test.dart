import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/sell_gold/domain/entities/checkout_confirm_entity.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/sell_gold_checkout_confirm_uc.dart';
import 'package:lakuemas/features/sell_gold/presentation/blocs/sell_gold_checkout_confirm/sell_gold_checkout_confirm_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sell_gold_checkout_confirm_bloc_test.mocks.dart';

@GenerateMocks([SellGoldCheckoutConfirmUc])
void main() {
  late MockSellGoldCheckoutConfirmUc mockSellGoldCheckoutConfirmUc;
  late SellGoldCheckoutConfirmBloc sellGoldCheckoutConfirmBloc;

  setUp(() {
    mockSellGoldCheckoutConfirmUc = MockSellGoldCheckoutConfirmUc();
    sellGoldCheckoutConfirmBloc = SellGoldCheckoutConfirmBloc(
        sellGoldCheckoutConfirmUc: mockSellGoldCheckoutConfirmUc);
  });

  group('Success checkout confirm sell gold', () {
    String trxKey = 'PRE990990990';

    const checkoutConfirmEntity = CheckoutConfirmEntity(
      transactionCode: 'PRE111111',
      transactionId: 1,
    );

    final event = SellGoldCheckoutConfirmNowEvent(trxKey);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockSellGoldCheckoutConfirmUc.call(
          transactionKey: trxKey,
        )).thenAnswer(
            (realInvocation) async => const Right(checkoutConfirmEntity));

        return sellGoldCheckoutConfirmBloc;
      },
      expectedStates: [
        SellGoldCheckoutConfirmLoadingState(),
        const SellGoldCheckoutConfirmSuccessState(
          checkoutConfirmEntity: checkoutConfirmEntity,
        ),
      ],
      verifyCall: () => verify(mockSellGoldCheckoutConfirmUc.call(
        transactionKey: trxKey,
      )),
    );
  });

  group('Error SellGoldCheckoutConfirm', () {
    String trxKey = 'PRE990990990';

    final event = SellGoldCheckoutConfirmNowEvent(trxKey);

    final failureTypes = [
      SessionFailure(),
      const ClientFailure(
          code: 400,
          messages: "The request parameter invalid",
          errors: {
            'field': 'field cannot be blank',
          }),
      const ServerFailure(),
      UnknownFailure(),
    ];

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockSellGoldCheckoutConfirmUc.call(
            transactionKey: trxKey,
          )).thenAnswer((realInvocation) async => Left(failureType));

          return sellGoldCheckoutConfirmBloc;
        },
        expectedStates: [
          SellGoldCheckoutConfirmLoadingState(),
          if (failureType is SessionFailure)
            SellGoldCheckoutConfirmFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const SellGoldCheckoutConfirmFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'field': 'field cannot be blank',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const SellGoldCheckoutConfirmFailureState(
                ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            SellGoldCheckoutConfirmFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockSellGoldCheckoutConfirmUc.call(
          transactionKey: trxKey,
        )),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required SellGoldCheckoutConfirmBloc Function() build,
  required List<SellGoldCheckoutConfirmState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<SellGoldCheckoutConfirmBloc, SellGoldCheckoutConfirmState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
