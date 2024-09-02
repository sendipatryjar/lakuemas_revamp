import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/update_address_entity.dart';
import '../../../domain/usecases/update_address_uc.dart';

part 'profile_address_update_event.dart';
part 'profile_address_update_state.dart';

class ProfileAddressUpdateBloc
    extends Bloc<ProfileAddressUpdateEvent, ProfileAddressUpdateState> {
  final UpdateAddressUc updateAddressUc;
  ProfileAddressUpdateBloc({
    required this.updateAddressUc,
  }) : super(ProfileAddressUpdateInitialState()) {
    on<ProfileAddressUpdatePressed>((event, emit) async {
      emit(ProfileAddressUpdateLoadingState());
      final result = await updateAddressUc(event.datas);
      result.fold(
        (l) => emit(ProfileAddressUpdateFailureState(l, l.code, l.messages)),
        (r) => emit(ProfileAddressUpdateSuccessState()),
      );
    });
  }
}
