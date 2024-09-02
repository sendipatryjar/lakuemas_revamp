import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/elite/domain/usecases/get_social_media_config_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/social_media_config_entity.dart';

part 'get_social_media_config_event.dart';
part 'get_social_media_config_state.dart';

class GetSocialMediaConfigBloc
    extends Bloc<GetSocialMediaConfigEvent, GetSocialMediaConfigState> {
  final GetSocialMediaConfigUc getSocialMediaConfigUc;

  GetSocialMediaConfigBloc({required this.getSocialMediaConfigUc})
      : super(GetSocialMediaConfigInitial()) {
    on<GetSocialMediaConfigLoadEvent>((event, emit) async {
      if (event.helperDataEliteCubit.state.socialMediaConfigEntity != null) {
        emit(GetSocialMediaConfigSuccessState(
            event.helperDataEliteCubit.state.socialMediaConfigEntity!));
        return;
      }
      emit(GetSocialMediaConfigLoadingState());
      final result = await getSocialMediaConfigUc();
      result.fold(
        (l) => emit(GetSocialMediaConfigFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateSocialMediaConfig(r);
          emit(GetSocialMediaConfigSuccessState(r));
        },
      );
    });
  }
}
