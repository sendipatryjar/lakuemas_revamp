import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/data/models/get_District_model.dart';
import 'package:lakuemas/features/profile/domain/usecases/get_districts_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_cities_uc_test.mocks.dart';

void main() {
  late MockIAddressRepository mockIAddressRepository;
  late GetDistrictsUc getDistrictsUc;
  late List<GetDistrictModel> getDistrictModel;

  setUpAll(() {
    mockIAddressRepository = MockIAddressRepository();
    getDistrictsUc = GetDistrictsUc(repository: mockIAddressRepository);
    getDistrictModel = [
      const GetDistrictModel(
        id: 1,
        name: 'test District 1',
        cityId: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
      const GetDistrictModel(
        id: 2,
        name: 'test District 2',
        cityId: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
    ];
  });

  group('Get District Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAddressRepository.getDistricts())
            .thenAnswer((realInvocation) async => Right(getDistrictModel));

        final result = await getDistrictsUc(
          GetDistrictsParams(),
        );

        expect(result, Right(getDistrictModel));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAddressRepository.getDistricts())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getDistrictsUc(
          GetDistrictsParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAddressRepository.getDistricts()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getDistrictsUc(
          GetDistrictsParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAddressRepository.getDistricts())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getDistrictsUc(
          GetDistrictsParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAddressRepository.getDistricts())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getDistrictsUc(
          GetDistrictsParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
