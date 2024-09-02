import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/laku_save/domain/repositories/i_lakusave_repoisitory.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/get_about_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_about_uc_test.mocks.dart';

@GenerateMocks([ILakusaveRepository])
void main() {
  late MockILakusaveRepository mockILakusaveRepository;
  late GetAboutUc getAboutUc;
  late String? res;

  setUpAll(() {
    mockILakusaveRepository = MockILakusaveRepository();
    getAboutUc = GetAboutUc(repository: mockILakusaveRepository);
    res = 'abcdefghijklmnopqrstuvwxyz';
  });

  group('Get About Usecase', () {
    test(
      'Success',
      () async {
        when(mockILakusaveRepository.getAbout())
            .thenAnswer((realInvocation) async => Right(res));

        final result = await getAboutUc();

        expect(result, Right(res));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILakusaveRepository.getAbout())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getAboutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILakusaveRepository.getAbout()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getAboutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILakusaveRepository.getAbout())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getAboutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILakusaveRepository.getAbout())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getAboutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
