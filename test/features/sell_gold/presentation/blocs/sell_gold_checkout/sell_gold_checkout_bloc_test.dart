import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';
import 'package:lakuemas/features/physical_pull/domain/entities/detail_charge_entity.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/sell_gold_checkout_uc.dart';
import 'package:lakuemas/features/sell_gold/presentation/blocs/sell_gold_checkout/sell_gold_checkout_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sell_gold_checkout_bloc_test.mocks.dart';

@GenerateMocks([SellGoldCheckoutUc])
void main() {
  late MockSellGoldCheckoutUc mockSellGoldCheckoutUc;
  late SellGoldCheckoutBloc sellGoldCheckoutBloc;

  setUp(() {
    mockSellGoldCheckoutUc = MockSellGoldCheckoutUc();
    sellGoldCheckoutBloc =
        SellGoldCheckoutBloc(sellGoldCheckoutUc: mockSellGoldCheckoutUc);
  });

  group('Success checkout sell gold', () {
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

    final event = SellGoldCheckoutNowEvent(amount, amountType);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockSellGoldCheckoutUc.call(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => const Right(checkoutEntity));

        return sellGoldCheckoutBloc;
      },
      expectedStates: [
        SellGoldCheckoutLoadingState(),
        const SellGoldCheckoutSuccessState(
          checkoutEntity: checkoutEntity,
        ),
      ],
      verifyCall: () => verify(mockSellGoldCheckoutUc.call(
        amount: amount,
        amountType: amountType,
      )),
    );
  });

  group('Error SellGoldCheckout', () {
    double amount = 10.0;
    String amountType = 'nominal';

    final event = SellGoldCheckoutNowEvent(amount, amountType);

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
          when(mockSellGoldCheckoutUc.call(
            amount: amount,
            amountType: amountType,
          )).thenAnswer((realInvocation) async => Left(failureType));

          return sellGoldCheckoutBloc;
        },
        expectedStates: [
          SellGoldCheckoutLoadingState(),
          if (failureType is SessionFailure)
            SellGoldCheckoutFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const SellGoldCheckoutFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'amoutType': 'amountType cannot than lower ',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const SellGoldCheckoutFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            SellGoldCheckoutFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockSellGoldCheckoutUc.call(
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
  required SellGoldCheckoutBloc Function() build,
  required List<SellGoldCheckoutState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<SellGoldCheckoutBloc, SellGoldCheckoutState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
