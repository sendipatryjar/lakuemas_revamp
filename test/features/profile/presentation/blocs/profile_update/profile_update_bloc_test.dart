// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import '../../../../features/_core/user/domain/entities/user_data_entity.dart';
// import '../../../../features/_core/user/domain/entities/user_setting_entity.dart';
// import '../../../../features/kyc/domain/entities/kyc_entity.dart';
// import '../../../../features/profile/domain/usecases/get_user_data_uc.dart';
// import '../../../../features/profile/domain/usecases/update_user_data_uc.dart';
// import '../../../../features/profile/presentation/blocs/profile/profile_bloc.dart';
// import '../../../../features/profile/presentation/blocs/profile_update/profile_update_bloc.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'profile_update_bloc_test.mocks.dart';

// @GenerateMocks([GetUserDataUc, UpdateUserDataUc])
// void main() {
//   late MockGetUserDataUc mockGetUserDataUc;
//   late MockUpdateUserDataUc mockUpdateUserDataUc;
//   late ProfileUpdateBloc profileUpdateBloc;
//   late UpdateUserDataParams updateUserDataParams;

//   setUp(() {
//     mockGetUserDataUc = MockGetUserDataUc();
//     mockUpdateUserDataUc = MockUpdateUserDataUc();
//     profileUpdateBloc = ProfileUpdateBloc(
//       getUserDataUc: mockGetUserDataUc,
//       updateUserDataUc: mockUpdateUserDataUc,
//     );
//     updateUserDataParams = UpdateUserDataParams(
//       fullName: 'Sunarto',
//       gender: 'Laki laki',
//       placeOfBirth: 'Surabaya',
//       dateOfBirth: '12-08-1999',
//       maritalStatus: 'Kawin',
//       religion: 'Islam',
//       occupation: 'occupation',
//       income: 'Gaji',
//       purpose: 'Investasi',
//     );
//   });
//   group('Success profile update', () {
//     const userData = UserDataEntity(
//       avatarUrl: 'avatarUrl',
//       customerTypeId: 1,
//       dateOfBirth: '11-02-2000',
//       email: 'email@gmail.com',
//       gender: 'Laki laki',
//       handphone: '089000111222',
//       id: 1,
//       income: 'Gaji',
//       isElite: true,
//       purpose: 'purpose',
//       occupation: 'occupation',
//       placeOfBirth: 'placeofbirth',
//       religion: 'religion',
//       name: 'name',
//       maritalStatus: 'maritalStatus',
//       pinStatus: true,
//       userSettingEntity: UserSettingEntity(
//         withPrice: true,
//         withPromo: true,
//       ),
//       userDataAddressEntity: [],
//       userFavoritesEntity: [],
//     );

//     // final event = SelfDataUpdatePressed(
//     //   fullName: updateUserDataParams.fullName,
//     //   gender: updateUserDataParams.gender,
//     //   pob: updateUserDataParams.placeOfBirth,
//     //   dob: updateUserDataParams.dateOfBirth,
//     //   maritalStatus: updateUserDataParams.maritalStatus,
//     //   religion: updateUserDataParams.religion,
//     // );

//     blocTest<ProfileUpdateBloc, ProfileUpdateState>(
//       'emits [MyState] when MyEvent is added.',
//       build: () {
//         when(mockGetUserDataUc(isFromLocal: true))
//             .thenAnswer((realInvocation) async => const Right(userData));
//         when(
//           mockUpdateUserDataUc(updateUserDataParams),
//         ).thenAnswer((realInvocation) async => const Right(true));

//         return profileUpdateBloc;
//       },
//       act: (bloc) => bloc.add(SelfDataUpdatePressed(
//         fullName: updateUserDataParams.fullName,
//         gender: updateUserDataParams.gender,
//         pob: updateUserDataParams.placeOfBirth,
//         dob: updateUserDataParams.dateOfBirth,
//         maritalStatus: updateUserDataParams.maritalStatus,
//         religion: updateUserDataParams.religion,
//       )),
//       expect: () => [
//         ProfileUpdateLoadingState(),
//         ProfileUpdateSuccessState(),
//       ],
//       verify: (bloc) => verify(mockUpdateUserDataUc(updateUserDataParams)),
//     );

//     // blocTestWithCommonCases(
//     //   description: 'Success self data update',
//     //   event: event,
//     //   build: () {
//     //     when(mockGetUserDataUc.call(isFromLocal: true))
//     //         .thenAnswer((realInvocation) async => const Right(userData));
//     //     when(mockUpdateUserDataUc.call(
//     //       updateUserDataParams,
//     //     )).thenAnswer((realInvocation) async => const Right(true));

//     //     return profileUpdateBloc;
//     //   },
//     //   expectedStates: [
//     //     ProfileUpdateLoadingState(),
//     //     ProfileUpdateSuccessState(),
//     //   ],
//     //   verifyCall: () => verify(mockUpdateUserDataUc.call(
//     //     updateUserDataParams,
//     //   )),
//     //
//   });
// }

// // void blocTestWithCommonCases({
// //   required String description,
// //   required dynamic event,
// //   required ProfileUpdateBloc Function() build,
// //   required List<ProfileUpdateState> expectedStates,
// //   required void Function() verifyCall,
// // }) {
// //   blocTest<ProfileUpdateBloc, ProfileUpdateState>(
// //     'emits [Loading, $description] when MyEvent is added.',
// //     build: build,
// //     act: (bloc) => bloc.add(event),
// //     expect: () => expectedStates,
// //     verify: (_) => verifyCall(),
// //   );
// // }
