import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:lakuemas/features/settings/domain/usecases/update_settings_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_settings_uc_test.mocks.dart';

@GenerateMocks([ISettingsRepository])
void main() {
  late MockISettingsRepository mockISettingsRepository;
  late UpdateSettingsUc updateSettingsUc;

  setUpAll(() {
    mockISettingsRepository = MockISettingsRepository();
    updateSettingsUc = UpdateSettingsUc(repository: mockISettingsRepository);
  });

  group('Update Settings Usecase', () {
    var updateSettingsReq = const UpdateSettingsParams(
      withPrice: true,
      withPromo: true,
    );
    // SESSION SUCCESS
    test('Success Update Settings with price', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => const Right(true));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, const Right(true));
    });

    test('Success Update Settings with promo', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => const Right(true));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, const Right(true));
    });

    test('Success Update Settings with price and promo', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => const Right(true));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, const Right(true));
    });

    test('Success Update Settings non active price and promo', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => const Right(true));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, const Right(true));
    });

    // SESSION FAILURE
    test('Update Settings SessionFailure', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => Left(SessionFailure()));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, isA<Left>());

      final result2 = result.fold((l) => l, (r) => r);

      expect(result2, isA<SessionFailure>());
    });

    test('Update Settings ClientFailure', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer(
          (realInvocation) async => const Left(MobileValidationFailure()));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, isA<Left>());

      final result2 = result.fold((l) => l, (r) => r);

      expect(result2, isA<MobileValidationFailure>());
    });

    test('Update Settings ServerFailure', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, isA<Left>());

      final result2 = result.fold((l) => l, (r) => r);

      expect(result2, isA<ServerFailure>());
    });

    test('Update Settings UnknownFailure', () async {
      when(mockISettingsRepository.updateSettings(
        updateSettingsReq: updateSettingsReq,
      )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

      final result = await updateSettingsUc(
        updateSettingsReq,
      );

      expect(result, isA<Left>());

      final result2 = result.fold((l) => l, (r) => r);

      expect(result2, isA<UnknownFailure>());
    });
  });
}
