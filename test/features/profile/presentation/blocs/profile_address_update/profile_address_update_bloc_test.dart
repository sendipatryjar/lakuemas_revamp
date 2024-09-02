import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';
import 'package:lakuemas/features/profile/domain/usecases/update_address_uc.dart';
import 'package:lakuemas/features/profile/presentation/blocs/profile_address_update/profile_address_update_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_address_update_bloc_test.mocks.dart';

@GenerateMocks([UpdateAddressUc])
void main() {
  late MockUpdateAddressUc mockUpdateAddressUc;
  late ProfileAddressUpdateBloc profileAddressUpdateBloc;

  setUp(() {
    mockUpdateAddressUc = MockUpdateAddressUc();
    profileAddressUpdateBloc =
        ProfileAddressUpdateBloc(updateAddressUc: mockUpdateAddressUc);
  });

  group('Success Update Address', () {
    List<UpdateAddressEntity> listUpdateAddress = [
      UpdateAddressEntity(
        districtId: 1,
        address: 'address',
        postalCode: '55555',
        type: 'home',
      ),
    ];
    final event = ProfileAddressUpdatePressed(listUpdateAddress);

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockUpdateAddressUc.call(listUpdateAddress))
            .thenAnswer((realInvocation) async => const Right(true));

        return profileAddressUpdateBloc;
      },
      expectedStates: [
        ProfileAddressUpdateLoadingState(),
        ProfileAddressUpdateSuccessState(),
      ],
      verifyCall: () => verify(mockUpdateAddressUc.call(listUpdateAddress)),
    );
  });

  group('Error Update Address', () {
    List<UpdateAddressEntity> listUpdateAddress = [
      UpdateAddressEntity(
        districtId: 1,
        address: 'address',
        postalCode: '55555',
        type: 'home',
      ),
    ];
    final event = ProfileAddressUpdatePressed(listUpdateAddress);

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
          when(mockUpdateAddressUc.call(listUpdateAddress))
              .thenAnswer((realInvocation) async => Left(failureType));

          return profileAddressUpdateBloc;
        },
        expectedStates: [
          ProfileAddressUpdateLoadingState(),
          if (failureType is SessionFailure)
            ProfileAddressUpdateFailureState(SessionFailure(), null, null),
          if (failureType is ClientFailure)
            const ProfileAddressUpdateFailureState(
                ClientFailure(
                    code: 400,
                    messages: "The request parameter invalid",
                    errors: {
                      'field': 'field cannot be blank',
                    }),
                400,
                'The request parameter invalid'),
          if (failureType is ServerFailure)
            const ProfileAddressUpdateFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            ProfileAddressUpdateFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockUpdateAddressUc.call(listUpdateAddress)),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required ProfileAddressUpdateBloc Function() build,
  required List<ProfileAddressUpdateState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<ProfileAddressUpdateBloc, ProfileAddressUpdateState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
