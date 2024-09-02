import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/cubits/helper_data/helper_data_cubit.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/get_price_uc.dart';
import 'package:lakuemas/features/buy_gold/presentation/blocs/pricing/pricing_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pricing_bloc_test.mocks.dart';

@GenerateMocks([GetPriceUc])
void main() {
  late MockGetPriceUc mockGetPriceUc;
  late PricingBloc pricingBloc;
  late HelperDataCubit helperDataCubit;

  setUp(() {
    mockGetPriceUc = MockGetPriceUc();
    pricingBloc = PricingBloc(getPriceUc: mockGetPriceUc);
    helperDataCubit = HelperDataCubit();
  });

  group('Success get pricing bGold', () {
    const pEntity = PriceEntity(
      elitePurchasePrice: '100000',
      eliteSellingPrice: '90000',
      minimumGrammation: '1',
      minimumNominal: '50000',
      placeholderGrammation: [],
      placeholderNominal: [],
      price: '100000',
      purchasePrice: '100000',
      sellingPrice: '90000',
      taxNominal: '25000',
      taxPercentage: '2',
    );

    final event = PricingGetEvent(helperDataCubit: helperDataCubit);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockGetPriceUc.call())
            .thenAnswer((realInvocation) async => const Right(pEntity));

        return pricingBloc;
      },
      expectedStates: [
        PricingLoadingState(),
        const PricingSuccessState(
          priceEntity: pEntity,
        ),
      ],
      verifyCall: () => verify(mockGetPriceUc.call()),
    );
  });

  group('Error get Pricing', () {
    final event = PricingGetEvent(helperDataCubit: helperDataCubit);
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
          when(mockGetPriceUc.call())
              .thenAnswer((realInvocation) async => Left(failureType));

          return pricingBloc;
        },
        expectedStates: [
          PricingLoadingState(),
          if (failureType is SessionFailure)
            PricingFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const PricingFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'field': 'field cannot be blank',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const PricingFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            PricingFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockGetPriceUc.call()),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required PricingBloc Function() build,
  required List<PricingState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<PricingBloc, PricingState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
