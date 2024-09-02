import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/get_about_uc.dart';

part 'lakusave_about_event.dart';
part 'lakusave_about_state.dart';

class LakusaveAboutBloc extends Bloc<LakusaveAboutEvent, LakusaveAboutState> {
  final GetAboutUc getAboutUc;

  LakusaveAboutBloc({required this.getAboutUc})
      : super(LakusaveAboutInitialState()) {
    on<LakusaveAboutGetEvent>((event, emit) async {
      emit(LakusaveAboutLoadingState());
      final result = await getAboutUc();
      result.fold(
        (l) => emit(LakusaveAboutFailureState(l, l.code, l.messages)),
        (r) => emit(LakusaveAboutSuccessState(data: r)),
      );
    });
  }
}
