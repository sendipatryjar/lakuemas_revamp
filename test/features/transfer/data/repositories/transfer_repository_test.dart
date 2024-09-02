import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/_core/user/data/models/user_data_model.dart';
import 'package:lakuemas/features/_core/user/data/models/user_setting_model.dart';
import 'package:lakuemas/features/_core/user/domain/entities/user_favorite_entity.dart';
import 'package:lakuemas/features/transfer/data/data_sources/interfaces/i_transfer_local_data_source.dart';
import 'package:lakuemas/features/transfer/data/data_sources/interfaces/i_transfer_remote_data_source.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_charge_model.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_checkout_model.dart';
import 'package:lakuemas/features/transfer/data/repositories/transfer_repository.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_checkout_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transfer_repository_test.mocks.dart';

@GenerateMocks([
  ITransferRemoteDataSource,
  ITransferLocalDataSource,
  ITokenLocalDataSource,
])
void main() {
  late MockITransferRemoteDataSource mockITransferRemoteDataSource;
  late MockITransferLocalDataSource mockITransferLocalDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late TransferRepository transferRepository;

  setUp(() {
    mockITransferRemoteDataSource = MockITransferRemoteDataSource();
    mockITransferLocalDataSource = MockITransferLocalDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    transferRepository = TransferRepository(
      remoteDataSource: mockITransferRemoteDataSource,
      localDataSource: mockITransferLocalDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  const bool isAddFavorite = true;
  const double goldWeight = 10.0;
  const String accountNumber = '111111';

  const String accessToken = 'accessToken';
  const String refreshToken = 'refreshToken';
  const String trxKey = 'PRE111111111';

  group('transfer repository', () {
    final tfChargeModel = TransferChargeModel.fromJson(const {
      'account_name': 'abogoboga',
      'account_number': '111111111',
      'gold_weight': '10',
      'transaction_key': 'PRE111111111',
    });

    final tfCheckoutModel = TransferCheckoutModel.fromJson(const {
      'transaction_code': 'PRE111111111',
    });

    const userData = UserDataModel(
      avatarUrl: 'avatarUrl',
      customerTypeId: 1,
      dateOfBirth: '11-02-2000',
      email: 'email@gmail.com',
      gender: 'Laki laki',
      handphone: '089000111222',
      id: 1,
      income: 'Gaji',
      isElite: true,
      purpose: 'purpose',
      occupation: 'occupation',
      placeOfBirth: 'placeofbirth',
      religion: 'religion',
      name: 'name',
      maritalStatus: 'maritalStatus',
      pinStatus: true,
      userSettingModel: UserSettingModel(
        withPrice: true,
        withPromo: true,
      ),
      userDataAddressModel: [],
      userFavoriteModel: [],
    );

    group('success transfer charge', () {
      test('200', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenAnswer(
          (_) async => BaseResp<TransferChargeModel>(
            code: 200,
            msgKey: 'SUCCESS',
            message: 'SUCCESS',
            data: tfChargeModel,
          ),
        );

        final result = await transferRepository.transferCharge(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );

        expect(result, Right<AppFailure, TransferChargeModel>(tfChargeModel));
      });
    });

    group('success transfer checkout', () {
      test('success transfer checkout 200', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        )).thenAnswer(
          (_) async => BaseResp<TransferCheckoutModel>(
            code: 200,
            msgKey: 'SUCCESS',
            message: 'SUCCESS',
            data: tfCheckoutModel,
          ),
        );

        final result =
            await transferRepository.transferCheckout(transactionKey: trxKey);
        expect(
            result, Right<AppFailure, TransferCheckoutEntity>(tfCheckoutModel));
      });
    });

    group('success getUserData', () {
      test('success getUserData 200', () async {
        when(mockITransferLocalDataSource.getUserData()).thenAnswer(
          (_) async => userData,
        );

        final result = await transferRepository.userFavorites();
        expect(
          result,
          Right<AppFailure, List<UserFavoriteEntity>>(
            userData.userFavoritesEntity ?? [],
          ),
        );
      });
    });

    //
    //
    // ERROR
    group('error transfer charge', () {
      test('session failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenThrow(SessionException());

        final result = await transferRepository.transferCharge(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );

        verify(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        ));

        expect(result, equals(Left(SessionFailure())));
      });

      test('client failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenThrow(
          ClientException(
            400,
            'email can not be null',
            {'field': 'field cannot be empty'},
          ),
        );

        final result = await transferRepository.transferCharge(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );

        verify(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        ));

        expect(
          result,
          equals(
            const Left(
              ClientFailure(
                code: 400,
                messages: 'email can not be null',
                errors: {'field': 'field cannot be empty'},
              ),
            ),
          ),
        );
      });
      test('server failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenThrow(
          ServerException(false),
        );

        final result = await transferRepository.transferCharge(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );

        verify(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        ));

        expect(result, equals(const Left(ServerFailure())));
      });

      test('unknown failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        )).thenThrow(
          UnknownException('unknown'),
        );

        final result = await transferRepository.transferCharge(
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );

        verify(mockITransferRemoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        ));

        expect(result, equals(Left(UnknownFailure())));
      });
    });

    // ERROR Transfer Checkout
    group('error transfer checkout', () {
      test('session failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        )).thenThrow(SessionException());

        final result = await transferRepository.transferCheckout(
          transactionKey: trxKey,
        );

        verify(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        ));

        expect(result, equals(Left(SessionFailure())));
      });

      test('client failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        )).thenThrow(
          ClientException(
            400,
            'email can not be null',
            {'field': 'field cannot be empty'},
          ),
        );

        final result = await transferRepository.transferCheckout(
          transactionKey: trxKey,
        );

        verify(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        ));

        expect(
          result,
          equals(
            const Left(
              ClientFailure(
                code: 400,
                messages: 'email can not be null',
                errors: {'field': 'field cannot be empty'},
              ),
            ),
          ),
        );
      });
      test('server failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        )).thenThrow(
          ServerException(false),
        );

        final result = await transferRepository.transferCheckout(
          transactionKey: trxKey,
        );

        verify(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        ));

        expect(result, equals(const Left(ServerFailure())));
      });

      test('unknown failure', () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((_) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        )).thenThrow(
          UnknownException('unknown'),
        );

        final result = await transferRepository.transferCheckout(
          transactionKey: trxKey,
        );

        verify(mockITransferRemoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: trxKey,
        ));

        expect(result, equals(Left(UnknownFailure())));
      });
    });

    // GetUserData from Local
    group('error getUserData', () {
      test('unknown failure', () async {
        when(mockITransferLocalDataSource.getUserData()).thenThrow(
          UnknownException('unknown'),
        );

        final result = await transferRepository.userFavorites();

        verify(mockITransferLocalDataSource.getUserData());

        expect(result, equals(Left(UnknownFailure())));
      });
    });
  });
}
