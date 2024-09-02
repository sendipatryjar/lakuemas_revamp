import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';
import 'package:lakuemas/features/profile/domain/usecases/update_address_uc.dart';
import 'package:mockito/mockito.dart';

import 'change_password_uc_test.mocks.dart';

void main() {
  late MockIProfileRepository mockIProfileRepository;
  late UpdateAddressUc updateAddressUc;
  late List<UpdateAddressEntity> listUpdateAddressEtt;

  setUpAll(() {
    mockIProfileRepository = MockIProfileRepository();
    updateAddressUc = UpdateAddressUc(repository: mockIProfileRepository);
    listUpdateAddressEtt = [
      UpdateAddressEntity(
        districtId: 1,
        address: 'update address 1',
        postalCode: '12345',
        type: '',
      ),
      UpdateAddressEntity(
        districtId: 2,
        address: 'update address 2',
        postalCode: '12345',
        type: '',
      ),
    ];
  });

  group('Update Address Usecase', () {
    test(
      'Success',
      () async {
        when(mockIProfileRepository.updateAddress(
                addressDatas: listUpdateAddressEtt))
            .thenAnswer((realInvocation) async => const Right(true));

        final result = await updateAddressUc(listUpdateAddressEtt);

        expect(result, const Right(true));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIProfileRepository.updateAddress(
                addressDatas: listUpdateAddressEtt))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await updateAddressUc(listUpdateAddressEtt);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIProfileRepository.updateAddress(
                addressDatas: listUpdateAddressEtt))
            .thenAnswer((realInvocation) async =>
                const Left(MobileValidationFailure()));

        final result = await updateAddressUc(listUpdateAddressEtt);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIProfileRepository.updateAddress(
                addressDatas: listUpdateAddressEtt))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await updateAddressUc(listUpdateAddressEtt);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIProfileRepository.updateAddress(
                addressDatas: listUpdateAddressEtt))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await updateAddressUc(listUpdateAddressEtt);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
