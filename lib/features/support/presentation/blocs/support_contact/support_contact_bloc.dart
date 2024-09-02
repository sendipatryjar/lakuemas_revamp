import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/get_support_contact_uc.dart';

part 'support_contact_event.dart';
part 'support_contact_state.dart';

class SupportContactBloc
    extends Bloc<SupportContactEvent, SupportContactState> {
  final GetSupportContactUc supportContactUc;

  SupportContactBloc({required this.supportContactUc})
      : super(SupportContactInitialState()) {
    on<SupportContactGetEvent>((event, emit) async {
      emit(SupportContactLoadingState());
      final reslt = await supportContactUc();
      reslt.fold(
        (l) => emit(SupportContactFailureState(l, l.code, l.messages)),
        (r) => emit(SupportContactSuccessState(
          email: r?.email,
          phone: r?.phoneNumber,
        )),
      );
    });
  }
}
