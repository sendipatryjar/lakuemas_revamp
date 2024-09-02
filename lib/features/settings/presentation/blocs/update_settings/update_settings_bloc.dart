import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/update_settings_uc.dart';

part 'update_settings_event.dart';
part 'update_settings_state.dart';

class UpdateSettingsBloc
    extends Bloc<UpdateSettingsEvent, UpdateSettingsState> {
  final UpdateSettingsUc updateSettingsUc;
  UpdateSettingsBloc({required this.updateSettingsUc})
      : super(UpdateSettingsInitialState()) {
    on<UpdateSettingsPressed>((event, emit) async {
      emit(UpdateSettingsLoadingState());
      final result = await updateSettingsUc(UpdateSettingsParams(
        withPrice: event.withPrice,
        withPromo: event.withPromo,
      ));
      result.fold(
        (l) => emit(UpdateSettingsFailureState(l, l.code, l.messages)),
        (r) => emit(UpdateSettingsSuccessState(
          withPrice: event.withPrice,
          withPromo: event.withPromo,
        )),
      );
    });
  }
}
