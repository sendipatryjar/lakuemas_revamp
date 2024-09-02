import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/elite/domain/entities/detail_offer_entity.dart';
import '../../../../../features/elite/domain/usecases/get_offer_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/get_my_offer_uc.dart';

part 'get_offer_event.dart';
part 'get_offer_state.dart';

class GetOfferBloc extends Bloc<GetOfferEvent, GetOfferState> {
  final GetOfferUc getOfferUc;
  final GetMyOfferUc getMyOfferUc;

  GetOfferBloc({
    required this.getOfferUc,
    required this.getMyOfferUc,
  }) : super(GetOfferInitial()) {
    on<GetOfferDetailEvent>((event, emit) async {
      emit(GetOfferLoadingState());
      final result = await getOfferUc(
        id: event.id,
      );
      result.fold(
        (l) => emit(GetOfferFailureState(l, l.code, l.messages)),
        (r) => emit(GetOfferSuccessState(r)),
      );
    });
    on<GetMyOfferDetailEvent>((event, emit) async {
      emit(GetOfferLoadingState());
      final result = await getMyOfferUc(
        id: event.id,
      );
      result.fold(
        (l) => emit(GetOfferFailureState(l, l.code, l.messages)),
        (r) => emit(GetOfferSuccessState(r)),
      );
    });
  }
}
