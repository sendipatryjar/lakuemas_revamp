import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/portofolio/domain/usecases/get_portofolio_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/entities/portofolio_entity.dart';

part 'get_portofolio_event.dart';
part 'get_portofolio_state.dart';

class GetPortofolioBloc extends Bloc<GetPortofolioEvent, GetPortofolioState> {
  final GetPortofolioUc getPortofolioUc;

  GetPortofolioBloc({required this.getPortofolioUc})
      : super(GetPortofolioInitial()) {
    on<GetPortofolioLoadEvent>((event, emit) async {
      if (event.helperDataCubit.state.portofolioEntity != null) {
        emit(GetPortofolioSuccessState(
            event.helperDataCubit.state.portofolioEntity!));
        return;
      }
      emit(GetPortofolioLoadingState());
      final result = await getPortofolioUc();
      result.fold(
        (l) => emit(GetPortofolioFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePortofolio(r);
          emit(GetPortofolioSuccessState(r));
        },
      );
    });
  }
}
