import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/user/domain/entities/user_data_entity.dart';
import '../../../domain/usecases/get_user_data_uc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDataUc getUserDataUc;

  ProfileBloc({
    // required this.eliteCubit,
    required this.getUserDataUc,
  }) : super(ProfileInitialState()) {
    on<ProfileGetDataEvent>((event, emit) async {
      if (event.helperDataCubit?.state.userDataEntity != null) {
        emit(ProfileSuccessState(event.helperDataCubit?.state.userDataEntity));
        return;
      }
      emit(ProfileLoadingState());
      final result = await getUserDataUc();
      result.fold(
        (l) => emit(ProfileFailureState(l, l.code, l.messages)),
        (r) {
          if (event.helperDataCubit != null) {
            event.helperDataCubit?.updateUserData(r);
          }
          event.eliteCubit?.change(r?.isElite ?? false);
          emit(ProfileSuccessState(r));
        },
      );
    });
  }
}
