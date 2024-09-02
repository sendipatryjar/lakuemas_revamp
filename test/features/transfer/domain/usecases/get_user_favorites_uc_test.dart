import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/user/domain/entities/user_favorite_entity.dart';
import 'package:lakuemas/features/transfer/domain/repositories/i_transfer_repository.dart';
import 'package:lakuemas/features/transfer/domain/usecases/get_user_favorites_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_favorites_uc_test.mocks.dart';

@GenerateMocks([ITransferRepository])
void main() {
  late MockITransferRepository mockITransferRepository;
  late GetUserFavoritesUc getUserFavoritesUc;

  setUp(() {
    mockITransferRepository = MockITransferRepository();
    getUserFavoritesUc =
        GetUserFavoritesUc(repository: mockITransferRepository);
  });

  group('get user fav', () {
    const userFavEntity = UserFavoriteEntity(
      accountName: 'abogoboga',
      accountNumber: '1111111111',
    );

    const listUserFavEntity = [
      userFavEntity,
      userFavEntity,
    ];

    // SUCCESS
    test('success', () async {
      when(mockITransferRepository.userFavorites())
          .thenAnswer((_) async => const Right(listUserFavEntity));

      final result = await getUserFavoritesUc();
      expect(result, const Right(listUserFavEntity));
    });

    // ERROR
    test('session failure', () async {
      when(mockITransferRepository.userFavorites())
          .thenAnswer((_) async => Left(SessionFailure()));

      final result = await getUserFavoritesUc();
      expect(result, Left(SessionFailure()));
    });

    test('client failure', () async {
      when(mockITransferRepository.userFavorites()).thenAnswer(
        (_) async => const Left(
          ClientFailure(
            code: 400,
            messages: 'email can not be empty',
            errors: {'field': 'field not be empty'},
          ),
        ),
      );

      final result = await getUserFavoritesUc();
      expect(
        result,
        const Left(
          ClientFailure(
            code: 400,
            messages: 'email can not be empty',
            errors: {'field': 'field not be empty'},
          ),
        ),
      );
    });

    test('server failure', () async {
      when(mockITransferRepository.userFavorites()).thenAnswer(
        (_) async => const Left(ServerFailure()),
      );

      final result = await getUserFavoritesUc();
      expect(result, const Left(ServerFailure()));
    });

    test('unknown failure', () async {
      when(mockITransferRepository.userFavorites()).thenAnswer(
        (_) async => Left(UnknownFailure()),
      );

      final result = await getUserFavoritesUc();
      expect(result, Left(UnknownFailure()));
    });
  });
}
