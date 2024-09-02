import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../../domain/usecases/get_terms_and_conditions_profile_uc.dart';

part 'terms_and_conditions_profile_event.dart';
part 'terms_and_conditions_profile_state.dart';

class TAndCProfileBloc extends Bloc<TAndCProfileEvent, TAndCProfileState> {
  final GetTermsAndConditionsProfileUc getTermsAndConditionsProfileUc;

  TAndCProfileBloc({required this.getTermsAndConditionsProfileUc})
      : super(TAndCProfileInitialState()) {
    on<TAndCProfileGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.termsAndConditionsEntity != null) {
        emit(TAndCProfileSuccessState(
            tAndCProfile:
                event.helperDataCubit.state.termsAndConditionsEntity));
        return;
      }
      emit(TAndCProfileLoadingState());
      final result = await getTermsAndConditionsProfileUc();
      result.fold(
        (l) => emit(TAndCProfileFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updateTermsAndConditions(r);
          emit(TAndCProfileSuccessState(tAndCProfile: r));
        },
      );
    });
  }
}
