import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/user/domain/entities/user_data_entity.dart';
import 'package:lakuemas/features/profile/domain/usecases/get_user_data_uc.dart';
import 'package:mockito/mockito.dart';

import 'change_password_uc_test.mocks.dart';

void main() {
  late MockIProfileRepository mockIProfileRepository;
  late GetUserDataUc getUserDataUc;
  late UserDataEntity userDataEntity;

  setUpAll(() {
    mockIProfileRepository = MockIProfileRepository();
    getUserDataUc = GetUserDataUc(repository: mockIProfileRepository);
    userDataEntity = const UserDataEntity();
  });

  group('Get User Data Usecase', () {
    test(
      'Success',
      () async {
        when(mockIProfileRepository.getUserData())
            .thenAnswer((realInvocation) async => Right(userDataEntity));

        final result = await getUserDataUc();

        expect(result, Right(userDataEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIProfileRepository.getUserData())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getUserDataUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIProfileRepository.getUserData()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getUserDataUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIProfileRepository.getUserData())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getUserDataUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIProfileRepository.getUserData())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getUserDataUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
