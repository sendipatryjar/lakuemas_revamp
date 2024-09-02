import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/guest_account_linking_uc.dart';

part 'avatar_guest_linking_event.dart';
part 'avatar_guest_linking_state.dart';

class AvatarGuestLinkingBloc extends Bloc<AvatarGuestLinkingEvent, AvatarGuestLinkingState> {
  final GuestAccountLinkingUc guestAccountLinkingUc;
  AvatarGuestLinkingBloc({required this.guestAccountLinkingUc}) : super(AvatarGuestLinkingInitialState()) {
    on<AvatarGuestLinkingGetEvent>((event, emit) async {
      emit(AvatarGuestLinkingLoadingState());
      final result = await guestAccountLinkingUc(userId: event.userId);
      result.fold(
        (l) => emit(AvatarGuestLinkingFailureState(l, l.code, l.messages)),
        (r) => emit(AvatarGuestLinkingSuccessState(token: r)),
      );
    });
  }
}
