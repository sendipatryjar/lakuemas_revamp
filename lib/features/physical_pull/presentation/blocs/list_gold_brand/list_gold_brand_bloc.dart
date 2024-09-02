import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/list_gold_brand_entity.dart';
import '../../../domain/usecases/get_list_gold_brand_uc.dart';

part 'list_gold_brand_event.dart';
part 'list_gold_brand_state.dart';

class ListGoldBrandBloc extends Bloc<ListGoldBrandEvent, ListGoldBrandState> {
  final GetListGoldBrandUc getListGoldBrandUc;
  ListGoldBrandBloc({required this.getListGoldBrandUc})
      : super(ListGoldBrandInitialState()) {
    on<ListGoldBrandEvent>((event, emit) async {
      emit(ListGoldBrandLoadingState());
      final result = await getListGoldBrandUc();
      result.fold(
        (l) => emit(ListGoldBrandFailureState(l, l.code, l.messages)),
        (r) {
          final listGoldBrand = r;
          final listAntam = r
              .where((element) => element.brand?.toLowerCase() == 'antam')
              .first;
          final listLotus = r
              .where((element) => element.brand?.toLowerCase() == 'lotus')
              .first;

          emit(ListGoldBrandSuccessState(
            listGoldBrandEntity: listGoldBrand,
            listAntam: listAntam,
            listLotus: listLotus,
          ));
        },
      );
    });
  }
}
