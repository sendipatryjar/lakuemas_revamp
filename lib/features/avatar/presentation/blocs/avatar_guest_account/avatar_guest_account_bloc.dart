import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/avatar_user_entity.dart';
import '../../../domain/usecases/create_guest_account_uc.dart';

part 'avatar_guest_account_event.dart';
part 'avatar_guest_account_state.dart';

class AvatarGuestAccountBloc extends Bloc<AvatarGuestAccountEvent, AvatarGuestAccountState> {
  final CreateGuestAccountUc createGuestAccountUc;
  AvatarGuestAccountBloc({required this.createGuestAccountUc}) : super(AvatarGuestAccountInitialState()) {
    on<AvatarGuestAccountCreateEvent>((event, emit) async {
      emit(AvatarGuestAccountLoadingState());
      final result = await createGuestAccountUc();
      result.fold(
        (l) => emit(AvatarGuestAccountFailureState(
          l,
          l.code,
          l.messages,
        )),
        (r) => emit(AvatarGuestAccountSuccessState(avatarUserEntity: r)),
      );
    });
  }
}
