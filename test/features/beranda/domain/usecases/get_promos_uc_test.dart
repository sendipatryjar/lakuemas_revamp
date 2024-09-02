import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/beranda/domain/entities/promo_entity.dart';
import 'package:lakuemas/features/beranda/domain/usecases/get_promos_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_menus_uc_test.mocks.dart';

void main() {
  late MockIBerandaRepository mockIBerandaRepository;
  late GetPromosUc getPromosUc;
  late List<PromoEntity> promos;

  setUpAll(() {
    mockIBerandaRepository = MockIBerandaRepository();
    getPromosUc = GetPromosUc(repository: mockIBerandaRepository);
    promos = const [
      PromoEntity(
        id: 1,
        title: 'title',
        content: 'content',
        imageUrl: 'imageUrl',
      ),
    ];
  });

  group('Get Promos Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBerandaRepository.getPromos(
          isActive: 1,
          limit: 100,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Right(promos));

        final result = await getPromosUc();

        expect(result, Right(promos));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBerandaRepository.getPromos(
          isActive: 1,
          limit: 100,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getPromosUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBerandaRepository.getPromos(
          isActive: 1,
          limit: 100,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getPromosUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBerandaRepository.getPromos(
          isActive: 1,
          limit: 100,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getPromosUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBerandaRepository.getPromos(
          isActive: 1,
          limit: 100,
          page: 1,
          orderBy: 'created_at',
          sortBy: 'desc',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getPromosUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
