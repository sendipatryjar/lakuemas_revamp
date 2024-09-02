import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/checkout_uc.dart';
import 'package:lakuemas/features/buy_gold/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:lakuemas/features/physical_pull/domain/entities/detail_charge_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_bloc_test.mocks.dart';

@GenerateMocks([CheckoutUc])
void main() {
  late MockCheckoutUc mockCheckoutUc;
  late CheckoutBloc checkoutBloc;

  setUp(() {
    mockCheckoutUc = MockCheckoutUc();
    checkoutBloc = CheckoutBloc(checkoutUc: mockCheckoutUc);
  });

  group('Success Checkout Buy Gold', () {
    double amount = 10.0;
    String amountType = 'nominal';

    const detailChargeEntity = DetailChargeEntity(
      goldBrand: 'Antam',
      goldFragment: 1,
      qty: 1,
      totalCertificateCost: '80000',
    );

    const checkoutEntity = CheckoutEntity(
      amount: '12000000',
      detail: [detailChargeEntity],
      goldAmount: '1000000',
      goldPrice: '980000',
      grossAmount: '120000',
      nominalTax: '50000',
      percentageTax: '22000',
      transactionKey: 'PRE111',
    );

    final event = CheckoutNowEvent(amount, amountType);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockCheckoutUc.call(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => const Right(checkoutEntity));

        return checkoutBloc;
      },
      expectedStates: [
        CheckoutLoadingState(),
        const CheckoutSuccessState(
          checkoutEntity: checkoutEntity,
        ),
      ],
      verifyCall: () => verify(mockCheckoutUc.call(
        amount: amount,
        amountType: amountType,
      )),
    );
  });

  group('Error SellGoldCheckout', () {
    double amount = 10.0;
    String amountType = 'nominal';

    final event = CheckoutNowEvent(amount, amountType);

    final failureTypes = [
      SessionFailure(),
      const ClientFailure(
          code: 400,
          messages: "The request parameter invalid",
          errors: {
            'amoutType': 'amountType cannot than lower ',
          }),
      const ServerFailure(),
      UnknownFailure(),
    ];

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockCheckoutUc.call(
            amount: amount,
            amountType: amountType,
          )).thenAnswer((realInvocation) async => Left(failureType));

          return checkoutBloc;
        },
        expectedStates: [
          CheckoutLoadingState(),
          if (failureType is SessionFailure)
            CheckoutFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const CheckoutFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'amoutType': 'amountType cannot than lower ',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const CheckoutFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            CheckoutFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockCheckoutUc.call(
          amount: amount,
          amountType: amountType,
        )),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required CheckoutBloc Function() build,
  required List<CheckoutState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<CheckoutBloc, CheckoutState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
