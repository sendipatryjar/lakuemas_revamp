import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../cores/errors/app_failure.dart';

import '../../../domain/usecases/get_privacy_policy_register_uc.dart';

part 'privacy_policy_register_event.dart';
part 'privacy_policy_register_state.dart';

class PrivacyPolicyRegisterBloc
    extends Bloc<PrivacyPolicyRegisterEvent, PrivacyPolicyRegisterState> {
  final GetPrivacyPolicyRegisterUc getPrivacyPolicyRegisterUc;

  PrivacyPolicyRegisterBloc({
    required this.getPrivacyPolicyRegisterUc,
  }) : super(PrivacyPolicyRegisterInitialState()) {
    on<PrivacyPolicyRegisterGetEvent>((event, emit) async {
      emit(PrivacyPolicyRegisterLoadingState());
      final result = await getPrivacyPolicyRegisterUc();
      result.fold(
        (l) => emit(PrivacyPolicyRegisterFailureState(l, l.code, l.messages)),
        (r) => emit(PrivacyPolicyRegisterSuccessState(htmlStr: r)),
      );
    });
  }
}
