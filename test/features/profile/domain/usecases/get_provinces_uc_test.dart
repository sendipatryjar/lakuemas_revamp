import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/data/models/get_Province_model.dart';
import 'package:lakuemas/features/profile/domain/usecases/get_Provinces_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_cities_uc_test.mocks.dart';

void main() {
  late MockIAddressRepository mockIAddressRepository;
  late GetProvincesUc getProvincesUc;
  late List<GetProvinceModel> getProvinceModel;

  setUpAll(() {
    mockIAddressRepository = MockIAddressRepository();
    getProvincesUc = GetProvincesUc(repository: mockIAddressRepository);
    getProvinceModel = [
      const GetProvinceModel(
        id: 1,
        name: 'test Province 1',
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
      const GetProvinceModel(
        id: 2,
        name: 'test Province 2',
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
    ];
  });

  group('Get Province Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAddressRepository.getProvinces())
            .thenAnswer((realInvocation) async => Right(getProvinceModel));

        final result = await getProvincesUc(
          GetProvincesParams(),
        );

        expect(result, Right(getProvinceModel));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAddressRepository.getProvinces())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getProvincesUc(
          GetProvincesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAddressRepository.getProvinces()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getProvincesUc(
          GetProvincesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAddressRepository.getProvinces())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getProvincesUc(
          GetProvincesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAddressRepository.getProvinces())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getProvincesUc(
          GetProvincesParams(),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
