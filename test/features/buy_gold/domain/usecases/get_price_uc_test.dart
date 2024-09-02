import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/repositories/i_buy_gold_repository.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/get_price_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_price_uc_test.mocks.dart';

@GenerateMocks([IBuyGoldRepository])
void main() {
  late MockIBuyGoldRepository mockIBuyGoldRepository;
  late GetPriceUc getPriceUc;
  late PriceEntity priceEntity;

  setUpAll(() {
    mockIBuyGoldRepository = MockIBuyGoldRepository();
    getPriceUc = GetPriceUc(repository: mockIBuyGoldRepository);
    priceEntity = const PriceEntity(
      price: '990000',
      taxPercentage: '3',
      minimumNominal: '50000',
      minimumGrammation: "0.05",
      placeholderNominal: ['100000', '200000'],
      placeholderGrammation: ["1.00", "2.00"],
    );
  });

  group('Get Price Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBuyGoldRepository.getPrice())
            .thenAnswer((realInvocation) async => Right(priceEntity));

        final result = await getPriceUc();

        expect(result, Right(priceEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBuyGoldRepository.getPrice())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getPriceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBuyGoldRepository.getPrice()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getPriceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBuyGoldRepository.getPrice())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getPriceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBuyGoldRepository.getPrice())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getPriceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
