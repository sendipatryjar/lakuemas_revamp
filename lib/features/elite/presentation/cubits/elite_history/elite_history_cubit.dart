import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/elite_history_entity.dart';
import '../../../domain/entities/elite_me_entity.dart';

part 'elite_history_state.dart';

class EliteHistoryCubit extends Cubit<EliteHistoryCubitState> {
  EliteHistoryCubit()
      : super(const EliteHistoryCubitState(
          enFilterPeriod: EnFilterPeriod.sevenDays,
        ));

  void changeFilter(EnFilterPeriod enFilterPeriod) => emit(state.copyWith(
        enFilterPeriod: enFilterPeriod,
        eliteHistoryEntity: [],
        listReferralEntity: [],
      ));

  void pickDate(List<DateTime?>? date) {
    emit(state.copyWith(date: date));
  }

  void changeDateSubsElite(String dateSubs) => emit(
        state.copyWith(dateSubsElite: dateSubs),
      );

  void updateLoadingTrue() => emit(state.copyWith(isLoading: true));

  void updateErrorTrue() => emit(state.copyWith(isError: true));

  void updateEliteHistory({
    required int page,
    List<EliteHistoryEntity>? eliteHistoryEntity,
    List<ListReferralEntity>? listReferralEntity,
    required MetaDataApi? metaData,
    bool isInitData = false,
  }) {
    List<EliteHistoryEntity> data = [];
    List<ListReferralEntity> dataReferral = [];
    if (isInitData == false) {
      data.addAll(state.eliteHistoryEntity);
      dataReferral.addAll(state.listReferralEntity);
    }
    data.addAll(eliteHistoryEntity ?? []);
    dataReferral.addAll(listReferralEntity ?? []);

    emit(state.copyWith(
      eliteHistoryEntity: data,
      listReferralEntity: dataReferral,
      isLoading: false,
      isError: false,
      meta: metaData,
    ));
  }
}
