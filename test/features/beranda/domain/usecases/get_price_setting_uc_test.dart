import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/beranda/domain/usecases/get_price_setting_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_menus_uc_test.mocks.dart';

void main() {
  late MockIBerandaRepository mockIBerandaRepository;
  late GetPriceSettingUc getPriceSettingUc;
  late PriceEntity priceEntity;

  setUpAll(() {
    mockIBerandaRepository = MockIBerandaRepository();
    getPriceSettingUc = GetPriceSettingUc(repository: mockIBerandaRepository);
    priceEntity = const PriceEntity(
      price: '990000',
      sellingPrice: '990000',
      eliteSellingPrice: '990000',
      purchasePrice: '980000',
      elitePurchasePrice: '980000',
      taxPercentage: '3',
      taxNominal: '3000',
      minimumNominal: '5000',
      minimumGrammation: '0.0506',
      placeholderNominal: ["100000", "200000", "300000"],
      placeholderGrammation: ["1.00", "2.00", "3.00"],
    );
  });

  group('Get Price Setting Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBerandaRepository.getPriceSetting())
            .thenAnswer((realInvocation) async => Right(priceEntity));

        final result = await getPriceSettingUc();

        expect(result, Right(priceEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBerandaRepository.getPriceSetting())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getPriceSettingUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBerandaRepository.getPriceSetting()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getPriceSettingUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBerandaRepository.getPriceSetting())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getPriceSettingUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBerandaRepository.getPriceSetting())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getPriceSettingUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
