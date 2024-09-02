// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import '../../../../cores/errors/app_failure.dart';
// import '../../../../features/login/domain/entities/login_entity.dart';
// import '../../../../features/login/domain/usecases/login_uc.dart';
// import '../../../../features/login/presentation/blocs/login/login_bloc.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'login_bloc_test.mocks.dart';

// @GenerateMocks([LoginUc, BuildContext])
// void main() {
//   late MockLoginUc mockLoginUc;
//   late LoginBloc loginBloc;
//   late MockBuildContext mockBuildContext;

//   setUp(() {
//     mockLoginUc = MockLoginUc();
//     mockBuildContext = MockBuildContext();
//     loginBloc = LoginBloc(loginUc: mockLoginUc);
//   });

//   group('Success Login', () {
//     const loginEntity = LoginEntity(
//       accessToken: 'accessToken',
//       refreshToken: 'refreshToken',
//       email: 'email',
//       phoneNumber: '089000000000',
//     );

//     final loginParams = LoginParams(
//       userName: 'userName',
//       password: 'password',
//     );

//     mockBuildContext = MockBuildContext();

//     final event = LoginPressed(
//       mockBuildContext,
//       loginParams.userName,
//       loginParams.password,
//     );

//     blocTestWithCommonCases(
//       description: 'Success',
//       event: event,
//       build: () {
//         when(mockLoginUc.call(loginParams))
//             .thenAnswer((realInvocation) async => const Right(loginEntity));

//         return loginBloc;
//       },
//       expectedStates: [
//         LoginLoading(),
//         LoginSuccess(
//           email: loginEntity.email,
//           phoneNumber: loginEntity.phoneNumber,
//         ),
//       ],
//       verifyCall: () => verify(mockLoginUc.call(loginParams)).called(2),
//     );
//   });

//   // group('Error Login', () {
//   //   final loginParams = LoginParams(
//   //     userName: 'userName',
//   //     password: 'password',
//   //   );

//   //   final event = LoginPressed(
//   //     MockBuildContext(),
//   //     loginParams.userName,
//   //     loginParams.password,
//   //   );

//   //   final failureTypes = [
//   //     SessionFailure(),
//   //     const ClientFailure(
//   //         code: 400,
//   //         messages: "The request parameter invalid",
//   //         errors: {
//   //           'field': 'field cannot be blank',
//   //         }),
//   //     const ServerFailure(),
//   //     UnknownFailure(),
//   //   ];

//   //   for (final failureType in failureTypes) {
//   //     blocTestWithCommonCases(
//   //       description: failureType.runtimeType.toString(),
//   //       event: event,
//   //       build: () {
//   //         when(mockLoginUc.call(loginParams))
//   //             .thenAnswer((realInvocation) async => Left(failureType));

//   //         return loginBloc;
//   //       },
//   //       expectedStates: [
//   //         LoginLoading(),
//   //         if (failureType is SessionFailure)
//   //           LoginFailure(SessionFailure(), null, null),
//   //         if (failureType is ClientFailure)
//   //           const LoginFailure(
//   //               ClientFailure(
//   //                   code: 400,
//   //                   messages: "The request parameter invalid",
//   //                   errors: {
//   //                     'field': 'field cannot be blank',
//   //                   }),
//   //               400,
//   //               'The request parameter invalid'),
//   //         if (failureType is ServerFailure)
//   //           const LoginFailure(ServerFailure(), null, null),
//   //         if (failureType is UnknownFailure)
//   //           LoginFailure(UnknownFailure(), null, null),
//   //       ],
//   //       verifyCall: () => verify(mockLoginUc.call(loginParams)),
//   //     );
//   //   }
//   // });
// }

// void blocTestWithCommonCases({
//   required String description,
//   required dynamic event,
//   required LoginBloc Function() build,
//   required List<LoginState> expectedStates,
//   required void Function() verifyCall,
// }) {
//   blocTest<LoginBloc, LoginState>(
//     'emits [Loading, $description] when MyEvent is added.',
//     build: build,
//     act: (bloc) => bloc.add(event),
//     expect: () => expectedStates,
//     verify: (_) => verifyCall(),
//   );
// }
