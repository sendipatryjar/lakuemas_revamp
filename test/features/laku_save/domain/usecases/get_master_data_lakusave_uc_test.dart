import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/laku_save/domain/entities/gold_deposit_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_duration_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_extend_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_interest_entity.dart';
import 'package:lakuemas/features/_core/others/domain/entities/terms_and_conditions_entity.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/get_master_data_lakusave_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_about_uc_test.mocks.dart';

void main() {
  late MockILakusaveRepository mockILakusaveRepository;
  late GetMasterDataLakusaveUc getMasterDataLakusaveUc;
  late GoldDepositEntity res;

  setUpAll(() {
    mockILakusaveRepository = MockILakusaveRepository();
    getMasterDataLakusaveUc =
        GetMasterDataLakusaveUc(repository: mockILakusaveRepository);
    TermsAndConditionsEntity? termsAndConditionsEntity =
        const TermsAndConditionsEntity(
      title: 'title',
      description: 'description',
    );
    List<LakusaveDurationEntity> durations = const [
      LakusaveDurationEntity(
        id: 1,
        duration: 4,
        type: 'type',
      ),
      LakusaveDurationEntity(
        id: 3,
        duration: 8,
        type: 'type',
      ),
      LakusaveDurationEntity(
        id: 3,
        duration: 12,
        type: 'type',
      ),
    ];
    List<LakusaveExtendEntity> extendss = const [
      LakusaveExtendEntity(
        id: 1,
        name: 'tidak perpanjang',
        description: 'description',
      ),
      LakusaveExtendEntity(
        id: 1,
        name: 'pokok',
        description: 'description',
      ),
      LakusaveExtendEntity(
        id: 1,
        name: 'pokok + modal',
        description: 'description',
      ),
    ];
    List<LakusaveInterestEntity> interests = const [
      LakusaveInterestEntity(
          id: 1,
          customerTypeId: 1,
          depositDurationId: 1,
          interest: 4,
          minimumBalance: 10,
          eliteMinimumBalance: 1,
          maximumBalance: 100,
          tax: 0,
          createdAt: 'createdAt',
          updatedAt: 'updatedAt'),
    ];
    res = GoldDepositEntity(
      durations: durations,
      eliteMinimumBalance: '1',
      extendss: extendss,
      interests: interests,
      minimumBalance: '10',
      termsAndConditionsEntity: termsAndConditionsEntity,
    );
  });

  group('Get Master Data Lakusave Usecase', () {
    test(
      'Success',
      () async {
        when(mockILakusaveRepository.getMasterData())
            .thenAnswer((realInvocation) async => Right(res));

        final result = await getMasterDataLakusaveUc();

        expect(result, Right(res));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILakusaveRepository.getMasterData())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getMasterDataLakusaveUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILakusaveRepository.getMasterData()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getMasterDataLakusaveUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILakusaveRepository.getMasterData())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getMasterDataLakusaveUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILakusaveRepository.getMasterData())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getMasterDataLakusaveUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
