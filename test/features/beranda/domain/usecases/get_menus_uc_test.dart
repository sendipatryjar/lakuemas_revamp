import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/beranda/domain/entities/menu_entity.dart';
import 'package:lakuemas/features/beranda/domain/repositories/i_beranda_repository.dart';
import 'package:lakuemas/features/beranda/domain/usecases/get_menus_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_menus_uc_test.mocks.dart';

@GenerateMocks([IBerandaRepository])
void main() {
  late MockIBerandaRepository mockIBerandaRepository;
  late GetMenusUc getMenusUc;
  late List<MenuEntity> menus;

  setUpAll(() {
    mockIBerandaRepository = MockIBerandaRepository();
    getMenusUc = GetMenusUc(repository: mockIBerandaRepository);
    menus = const [
      MenuEntity(
        id: 1,
        name: 'name',
        description: 'description',
        parentId: 1,
        position: 1,
        isActive: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      ),
    ];
  });

  group('Get Menus Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBerandaRepository.getMenus())
            .thenAnswer((realInvocation) async => Right(menus));

        final result = await getMenusUc();

        expect(result, Right(menus));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBerandaRepository.getMenus())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getMenusUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBerandaRepository.getMenus()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getMenusUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBerandaRepository.getMenus())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getMenusUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBerandaRepository.getMenus())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getMenusUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
