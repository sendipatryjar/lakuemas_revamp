import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/profile/domain/entities/detail_district_entity.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/usecases/get_detail_district_uc.dart';

part 'detail_district_event.dart';
part 'detail_district_state.dart';

class DetailDistrictBloc
    extends Bloc<DetailDistrictEvent, DetailDistrictState> {
  final GetDetailDistrictUc getDetailDistrictUc;

  DetailDistrictBloc({required this.getDetailDistrictUc})
      : super(DetailDistrictInitial()) {
    on<DetailDistrictGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.homeDetailDistrict != null) {
        emit(DetailDistrictSuccessState(
            event.helperDataCubit.state.homeDetailDistrict!));
        return;
      }
      emit(DetailDistrictLoadingState());
      final result = await getDetailDistrictUc(id: event.id);

      result.fold(
        (l) => emit(DetailDistrictFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updateHomeDetailDistrict(r);
          emit(DetailDistrictSuccessState(r));
        },
      );
    });

    on<DetailDistrictMailGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.mailDetailDistrict != null) {
        emit(DetailDistrictSuccessState(
            event.helperDataCubit.state.mailDetailDistrict!));
        return;
      }
      emit(DetailDistrictLoadingState());
      final result = await getDetailDistrictUc(id: event.id);

      result.fold(
        (l) => emit(DetailDistrictFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updateMailDetailDistrict(r);
          emit(DetailDistrictSuccessState(r));
        },
      );
    });
  }
}
