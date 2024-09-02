import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/cubits/elite/elite_cubit.dart';
import 'package:lakuemas/cores/services/cubits/helper_data/helper_data_cubit.dart';
import 'package:lakuemas/features/_core/user/domain/entities/user_data_entity.dart';
import 'package:lakuemas/features/_core/user/domain/entities/user_setting_entity.dart';
import 'package:lakuemas/features/profile/domain/usecases/get_user_data_uc.dart';
import 'package:lakuemas/features/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_bloc_test.mocks.dart';

@GenerateMocks([GetUserDataUc])
void main() {
  late MockGetUserDataUc mockGetUserDataUc;
  late ProfileBloc profileBloc;

  setUp(() {
    mockGetUserDataUc = MockGetUserDataUc();
    profileBloc = ProfileBloc(getUserDataUc: mockGetUserDataUc);
  });

  group('Success Get Data User', () {
    const userData = UserDataEntity(
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
      userSettingEntity: UserSettingEntity(
        withPrice: true,
        withPromo: true,
      ),
      userDataAddressEntity: [],
      userFavoritesEntity: [],
    );

    final event = ProfileGetDataEvent(
      eliteCubit: EliteCubit(),
      helperDataCubit: HelperDataCubit(),
    );

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockGetUserDataUc.call(isFromLocal: false))
            .thenAnswer((realInvocation) async => const Right(userData));

        return profileBloc;
      },
      expectedStates: [
        ProfileLoadingState(),
        const ProfileSuccessState(userData),
      ],
      verifyCall: () => verify(mockGetUserDataUc.call(isFromLocal: false)),
    );
  });

  group('Error Get user Profile', () {
    final event = ProfileGetDataEvent(
      eliteCubit: EliteCubit(),
      helperDataCubit: HelperDataCubit(),
    );

    final failureTypes = [
      SessionFailure(),
      const ClientFailure(
          code: 400,
          messages: "The request parameter invalid",
          errors: {
            'field': 'field cannot be blank',
          }),
      const ServerFailure(),
      UnknownFailure(),
    ];

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockGetUserDataUc.call(isFromLocal: false))
              .thenAnswer((realInvocation) async => Left(failureType));

          return profileBloc;
        },
        expectedStates: [
          ProfileLoadingState(),
          if (failureType is SessionFailure)
            ProfileFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const ProfileFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'field': 'field cannot be blank',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const ProfileFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            ProfileFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockGetUserDataUc.call(isFromLocal: false)),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required ProfileBloc Function() build,
  required List<ProfileState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<ProfileBloc, ProfileState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
