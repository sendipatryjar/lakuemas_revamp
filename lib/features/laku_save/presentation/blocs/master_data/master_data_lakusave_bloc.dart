import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/gold_deposit_entity.dart';
import '../../../domain/usecases/get_master_data_lakusave_uc.dart';

part 'master_data_lakusave_event.dart';
part 'master_data_lakusave_state.dart';

class MasterDataLakusaveBloc
    extends Bloc<MasterDataLakusaveEvent, MasterDataLakusaveState> {
  final GetMasterDataLakusaveUc getMasterDataLakusaveUc;

  MasterDataLakusaveBloc({required this.getMasterDataLakusaveUc})
      : super(MasterDataLakusaveInitialState()) {
    on<MasterDataLakusaveGetEvent>((event, emit) async {
      emit(MasterDataLakusaveLoadingState());
      final result = await getMasterDataLakusaveUc();
      result.fold(
        (l) => emit(MasterDataLakusaveFailureState(l, l.code, l.messages)),
        (r) {
          emit(MasterDataLakusaveSuccessState(
            goldDepositEntity: r,
          ));
        },
      );
    });
  }
}
