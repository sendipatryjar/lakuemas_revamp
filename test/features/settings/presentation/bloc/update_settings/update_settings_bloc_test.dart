import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/settings/domain/usecases/update_settings_uc.dart';
import 'package:lakuemas/features/settings/presentation/blocs/update_settings/update_settings_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_settings_bloc_test.mocks.dart';

@GenerateMocks([UpdateSettingsUc])
void main() {
  late MockUpdateSettingsUc mockUpdateSettingsUc;
  late UpdateSettingsBloc updateSettingsBloc;
  late UpdateSettingsParams updateSettingsParams;

  setUp(() {
    mockUpdateSettingsUc = MockUpdateSettingsUc();
    updateSettingsBloc =
        UpdateSettingsBloc(updateSettingsUc: mockUpdateSettingsUc);
    updateSettingsParams = const UpdateSettingsParams(
      withPrice: true,
      withPromo: true,
    );
  });

  group('Success Update Settings', () {
    blocTest<UpdateSettingsBloc, UpdateSettingsState>(
      'emits [Loading, Success] when MyEvent is added.',
      build: () {
        when(mockUpdateSettingsUc.call(updateSettingsParams)).thenAnswer(
          (realInvocation) async => const Right(true),
        );
        return updateSettingsBloc;
      },
      act: (bloc) => updateSettingsBloc.add(
        UpdateSettingsPressed(
          withPrice: updateSettingsParams.withPrice,
          withPromo: updateSettingsParams.withPromo,
        ),
      ),
      expect: () => [
        UpdateSettingsLoadingState(),
        UpdateSettingsSuccessState(
          withPrice: updateSettingsParams.withPrice,
          withPromo: updateSettingsParams.withPromo,
        ),
      ],
      verify: (bloc) {
        verify(mockUpdateSettingsUc.call(updateSettingsParams));
      },
    );
  });

  group('Error Update Settings', () {
    blocTest<UpdateSettingsBloc, UpdateSettingsState>(
      'emits [Loading, SessionFailure] when MyEvent is added.',
      build: () {
        when(mockUpdateSettingsUc.call(updateSettingsParams))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));
        return updateSettingsBloc;
      },
      act: (bloc) => updateSettingsBloc.add(
        UpdateSettingsPressed(
          withPrice: updateSettingsParams.withPrice,
          withPromo: updateSettingsParams.withPromo,
        ),
      ),
      expect: () => [
        UpdateSettingsLoadingState(),
        UpdateSettingsFailureState(SessionFailure(), null, null),
      ],
      verify: (bloc) {
        verify(mockUpdateSettingsUc.call(updateSettingsParams)).called(1);
      },
    );

    blocTest<UpdateSettingsBloc, UpdateSettingsState>(
      'emits [Loading, ClientFailure] when MyEvent is added.',
      build: () {
        when(mockUpdateSettingsUc.call(updateSettingsParams)).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));
        return updateSettingsBloc;
      },
      act: (bloc) {
        updateSettingsBloc.add(
          UpdateSettingsPressed(
            withPrice: updateSettingsParams.withPrice,
            withPromo: updateSettingsParams.withPromo,
          ),
        );
        return;
      },
      expect: () => [
        UpdateSettingsLoadingState(),
        const UpdateSettingsFailureState(MobileValidationFailure(), null, null),
      ],
      verify: (bloc) {
        verify(mockUpdateSettingsUc.call(updateSettingsParams)).called(1);
      },
    );

    blocTest<UpdateSettingsBloc, UpdateSettingsState>(
      'emits [Loading, ServerFailure] when MyEvent is added.',
      build: () {
        when(mockUpdateSettingsUc.call(updateSettingsParams))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));
        return updateSettingsBloc;
      },
      act: (bloc) => updateSettingsBloc.add(
        UpdateSettingsPressed(
          withPrice: updateSettingsParams.withPrice,
          withPromo: updateSettingsParams.withPromo,
        ),
      ),
      expect: () => [
        UpdateSettingsLoadingState(),
        const UpdateSettingsFailureState(ServerFailure(), null, null),
      ],
      verify: (bloc) {
        verify(mockUpdateSettingsUc.call(updateSettingsParams));
      },
    );

    blocTest<UpdateSettingsBloc, UpdateSettingsState>(
      'emits [Loading, UnknownFailure] when MyEvent is added.',
      build: () {
        when(mockUpdateSettingsUc.call(updateSettingsParams))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));
        return updateSettingsBloc;
      },
      act: (bloc) => updateSettingsBloc.add(
        UpdateSettingsPressed(
          withPrice: updateSettingsParams.withPrice,
          withPromo: updateSettingsParams.withPromo,
        ),
      ),
      expect: () => [
        UpdateSettingsLoadingState(),
        UpdateSettingsFailureState(UnknownFailure(), null, null),
      ],
      verify: (bloc) {
        verify(mockUpdateSettingsUc.call(updateSettingsParams));
      },
    );
  });
}
