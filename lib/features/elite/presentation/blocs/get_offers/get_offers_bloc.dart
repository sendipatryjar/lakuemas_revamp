import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/offer_entity.dart';
import '../../../domain/usecases/get_offers_uc.dart';

part 'get_offers_event.dart';
part 'get_offers_state.dart';

class GetOffersBloc extends Bloc<GetOffersEvent, GetOffersState> {
  final GetOffersUc getOffersUc;
  GetOffersBloc({required this.getOffersUc}) : super(GetOffersInitial()) {
    on<GetOffersLoadEvent>((event, emit) async {
      if ((event.helperDataEliteCubit.state.listOfferEntity ?? []).isNotEmpty) {
        emit(GetOffersSuccessState(
            event.helperDataEliteCubit.state.listOfferEntity!));
        return;
      }
      emit(GetOffersLoadingState());
      final result = await getOffersUc();
      result.fold(
        (l) => emit(GetOffersFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateListOfferEntity(r);
          emit(GetOffersSuccessState(r));
        },
      );
    });
  }
}
