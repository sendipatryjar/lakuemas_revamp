import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/elite/domain/entities/elite_history_entity.dart';
import '../../../../../features/elite/domain/usecases/elite_history_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/elite_me_entity.dart';
import '../../../domain/usecases/get_list_referral_uc.dart';

part 'elite_history_event.dart';
part 'elite_history_state.dart';

class EliteHistoryBloc extends Bloc<EliteHistoryEvent, EliteHistoryState> {
  final EliteHistoryUc eliteHistoryUc;
  final GetListReferralUc getListReferralUc;

  EliteHistoryBloc({
    required this.eliteHistoryUc,
    required this.getListReferralUc,
  }) : super(EliteHistoryInitial()) {
    on<EliteHistoryGetEvent>((event, emit) async {
      emit(EliteHistoryLoadingState());
      final result = await eliteHistoryUc(
        limit: event.limit,
        page: event.page,
        orderBy: event.orderBy,
        sortBy: event.sortBy,
        startDate: event.startDate,
        endDate: event.endDate,
        statuses: event.statuses,
        period: event.period,
      );
      result.fold(
        (l) => emit(EliteHistoryFailureState(l, l.code, l.messages)),
        (r) {
          var data = r.data;
          emit(EliteHistorySuccessState(
            isInitData: event.isInitData,
            metaData: r.meta,
            eliteHistory: data,
          ));
        },
      );
    });

    on<GetEliteReferralsLoadEvent>((event, emit) async {
      emit(EliteHistoryLoadingState());
      final result = await getListReferralUc(
        limit: event.limit,
        page: event.page,
        startDate: event.startDate,
        endDate: event.endDate,
        startValidDate: event.startValidDate,
        endValidDate: event.endValidDate,
      );
      result.fold(
        (l) => emit(EliteHistoryFailureState(l, l.code, l.messages)),
        (r) {
          var data = r.data;
          emit(EliteHistorySuccessState(
            isInitData: event.isInitData,
            metaData: r.meta,
            listReferralEntity: data,
          ));
        },
      );
    });
  }
}
