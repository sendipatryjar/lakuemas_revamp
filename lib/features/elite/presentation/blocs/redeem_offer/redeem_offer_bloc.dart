import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/elite/domain/usecases/redeem_offer_uc.dart';

import '../../../../../cores/errors/app_failure.dart';

part 'redeem_offer_event.dart';
part 'redeem_offer_state.dart';

class RedeemOfferBloc extends Bloc<RedeemOfferEvent, RedeemOfferState> {
  final RedeemOfferUc redeemOfferUc;
  RedeemOfferBloc({required this.redeemOfferUc}) : super(RedeemOfferInitial()) {
    on<RedeemOfferPostEvent>((event, emit) async {
      emit(RedeemOfferLoadingState());
      final result = await redeemOfferUc(
        id: event.id,
      );
      result.fold(
        (l) => emit(RedeemOfferFailureState(l, l.code, l.messages)),
        (r) => emit(RedeemOfferSuccessState()),
      );
    });
  }
}
