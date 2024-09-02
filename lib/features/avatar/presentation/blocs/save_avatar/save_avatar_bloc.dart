import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/save_avatar_uc.dart';

part 'save_avatar_event.dart';
part 'save_avatar_state.dart';

class SaveAvatarBloc extends Bloc<SaveAvatarEvent, SaveAvatarState> {
  final SaveAvatarUc saveAvatarUc;
  SaveAvatarBloc({required this.saveAvatarUc})
      : super(SaveAvatarInitialState()) {
    on<SaveAvatarNowEvent>((event, emit) async {
      emit(SaveAvatarLoadingState());
      final result = await saveAvatarUc(imageUrl: event.imageUrl);
      result.fold(
        (l) => emit(SaveAvatarFailureState(l, l.code, l.messages)),
        (r) => emit(SaveAvatarSuccessState()),
      );
    });
  }
}
