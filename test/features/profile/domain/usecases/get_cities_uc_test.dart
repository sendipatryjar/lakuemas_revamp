import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/data/models/get_city_model.dart';
import 'package:lakuemas/features/profile/domain/repositories/i_address_repository.dart';
import 'package:lakuemas/features/profile/domain/usecases/get_cities_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cities_uc_test.mocks.dart';

@GenerateMocks([IAddressRepository])
void main() {
  late MockIAddressRepository mockIAddressRepository;
  late GetCitiesUc getCitiesUc;
  late List<GetCityModel> getCityModel;

  setUpAll(() {
    mockIAddressRepository = MockIAddressRepository();
    getCitiesUc = GetCitiesUc(repository: mockIAddressRepository);
    getCityModel = [
      const GetCityModel(
        id: 1,
        city: 'test city 1',
        provinceId: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
      const GetCityModel(
        id: 2,
        city: 'test city 2',
        provinceId: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
    ];
  });

  group('Get Cities Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAddressRepository.getCities())
            .thenAnswer((realInvocation) async => Right(getCityModel));

        final result = await getCitiesUc(
          GetCitiesParams(),
        );

        expect(result, Right(getCityModel));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAddressRepository.getCities())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getCitiesUc(
          GetCitiesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAddressRepository.getCities()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getCitiesUc(
          GetCitiesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAddressRepository.getCities())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getCitiesUc(
          GetCitiesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAddressRepository.getCities())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getCitiesUc(
          GetCitiesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
