import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/get_user_data_uc.dart';
import '../../../domain/usecases/update_user_data_uc.dart';

part 'profile_update_event.dart';
part 'profile_update_state.dart';

class ProfileUpdateBloc extends Bloc<ProfileUpdateEvent, ProfileUpdateState> {
  final GetUserDataUc getUserDataUc;
  final UpdateUserDataUc updateUserDataUc;
  ProfileUpdateBloc({
    required this.getUserDataUc,
    required this.updateUserDataUc,
  }) : super(ProfileUpdateInitialState()) {
    on<EmailUpdatePressed>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      final result = await updateUserDataUc(UpdateUserDataParams(
        email: event.email,
      ));
      result.fold(
        (l) => emit(ProfileUpdateFailureState(l, l.code, l.messages)),
        (r) => emit(ProfileUpdateSuccessState()),
      );
    });

    on<PhoneNumberUpdatePressed>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      final result = await updateUserDataUc(UpdateUserDataParams(
        phoneNumber: event.phoneNumber,
      ));
      result.fold(
        (l) => emit(ProfileUpdateFailureState(l, l.code, l.messages)),
        (r) => emit(ProfileUpdateSuccessState()),
      );
    });

    on<SelfDataUpdatePressed>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      final resUserData = await getUserDataUc(isFromLocal: true);
      final userData = resUserData.getOrElse(() => null);
      final result = await updateUserDataUc(UpdateUserDataParams(
        fullName:
            (event.fullName ?? '').isNotEmpty ? event.fullName : userData?.name,
        gender:
            (event.gender ?? '').isNotEmpty ? event.gender : userData?.gender,
        countryOfBirth:
            (event.cob ?? '').isNotEmpty ? event.cob : userData?.countryOfBirth,
        placeOfBirth:
            (event.pob ?? '').isNotEmpty ? event.pob : userData?.placeOfBirth,
        dateOfBirth:
            (event.dob ?? '').isNotEmpty ? event.dob : userData?.dateOfBirth,
        maritalStatus: (event.maritalStatus ?? '').isNotEmpty
            ? event.maritalStatus
            : userData?.maritalStatus,
        religion: (event.religion ?? '').isNotEmpty
            ? event.religion
            : userData?.religion,
        occupation: userData?.occupation,
        income: userData?.income,
        purpose: userData?.purpose,
      ));
      result.fold(
        (l) => emit(ProfileUpdateFailureState(l, l.code, l.messages)),
        (r) => emit(ProfileUpdateSuccessState()),
      );
    });

    on<IncomeDataUpdatePressed>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      final resUserData = await getUserDataUc(isFromLocal: true);
      final userData = resUserData.getOrElse(() => null);
      final result = await updateUserDataUc(UpdateUserDataParams(
        fullName: userData?.name,
        gender: userData?.gender,
        placeOfBirth: userData?.placeOfBirth,
        dateOfBirth: userData?.dateOfBirth,
        maritalStatus: userData?.maritalStatus,
        religion: userData?.religion,
        occupation: (event.occupation ?? '').isNotEmpty
            ? event.occupation
            : userData?.occupation,
        income:
            (event.income ?? '').isNotEmpty ? event.income : userData?.income,
        purpose: (event.purpose ?? '').isNotEmpty
            ? event.purpose
            : userData?.purpose,
      ));
      result.fold(
        (l) => emit(ProfileUpdateFailureState(l, l.code, l.messages)),
        (r) => emit(ProfileUpdateSuccessState()),
      );
    });
  }
}
