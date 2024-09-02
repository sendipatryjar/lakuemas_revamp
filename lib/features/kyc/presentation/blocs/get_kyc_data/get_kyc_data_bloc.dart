import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/object_kyc_entity.dart';
import '../../../domain/usecases/get_kyc_data_uc.dart';

part 'get_kyc_data_event.dart';
part 'get_kyc_data_state.dart';

class GetKycDataBloc extends Bloc<GetKycDataEvent, GetKycDataState> {
  final GetKycDataUc getKycDataUc;

  GetKycDataBloc({required this.getKycDataUc}) : super(GetKycDataInitial()) {
    on<GetKycTriggered>((event, emit) async {
      emit(GetKycDataLoadingState());
      final result = await getKycDataUc();
      result.fold(
        (l) => emit(GetKycDataFailureState(l, l.code, l.messages)),
        (r) {
          emit(GetKycDataSuccessState(r.objectKyc));
        },
      );
    });
  }
}
