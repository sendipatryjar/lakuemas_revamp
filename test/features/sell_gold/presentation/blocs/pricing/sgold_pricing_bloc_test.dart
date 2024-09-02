import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/cubits/helper_data/helper_data_cubit.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/get_price_uc.dart';
import 'package:lakuemas/features/sell_gold/presentation/blocs/pricing/sgold_pricing_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sgold_pricing_bloc_test.mocks.dart';

@GenerateMocks([GetPriceUc])
void main() {
  late MockGetPriceUc mockGetPriceUc;
  late SgoldPricingBloc sgoldPricingBloc;
  late HelperDataCubit helperDataCubit;

  setUp(() {
    mockGetPriceUc = MockGetPriceUc();
    sgoldPricingBloc = SgoldPricingBloc(getPriceUc: mockGetPriceUc);
    helperDataCubit = HelperDataCubit();
  });

  group('Success get Balance sell gold', () {
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

    // final listBalance = [bEntity];
    final event = SgoldPricingGetEvent(helperDataCubit: helperDataCubit);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockGetPriceUc.call())
            .thenAnswer((realInvocation) async => const Right(pEntity));

        return sgoldPricingBloc;
      },
      expectedStates: [
        SgoldPricingLoadingState(),
        const SgoldPricingSuccessState(
          priceEntity: pEntity,
        ),
      ],
      verifyCall: () => verify(mockGetPriceUc.call()),
    );
  });

  group('Error get Pricing', () {
    final event = SgoldPricingGetEvent(helperDataCubit: helperDataCubit);
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

          return sgoldPricingBloc;
        },
        expectedStates: [
          SgoldPricingLoadingState(),
          if (failureType is SessionFailure)
            SgoldPricingFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const SgoldPricingFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'field': 'field cannot be blank',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const SgoldPricingFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            SgoldPricingFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockGetPriceUc.call()),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required SgoldPricingBloc Function() build,
  required List<SgoldPricingState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<SgoldPricingBloc, SgoldPricingState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
