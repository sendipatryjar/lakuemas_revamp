import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/elite/domain/usecases/get_my_offers_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/offer_entity.dart';

part 'get_my_offers_event.dart';
part 'get_my_offers_state.dart';

class GetMyOffersBloc extends Bloc<GetMyOffersEvent, GetMyOffersState> {
  final GetMyOffersUc getMyOffersUc;
  GetMyOffersBloc({required this.getMyOffersUc}) : super(GetMyOffersInitial()) {
    on<GetMyOffersLoadEvent>((event, emit) async {
      if ((event.helperDataEliteCubit.state.listMyOfferEntity ?? [])
          .isNotEmpty) {
        emit(GetMyOffersSuccessState(
            event.helperDataEliteCubit.state.listMyOfferEntity!));
      }
      emit(GetMyOffersLoadingState());
      final result = await getMyOffersUc();
      result.fold(
        (l) => emit(GetMyOffersFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateListMyOfferEntity(r);
          emit(GetMyOffersSuccessState(r));
        },
      );
    });
  }
}
