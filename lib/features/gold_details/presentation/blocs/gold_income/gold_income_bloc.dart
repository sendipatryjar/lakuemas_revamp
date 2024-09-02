import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/gold_income_entity.dart';
import '../../../domain/usecases/get_gold_income_uc.dart';

part 'gold_income_event.dart';
part 'gold_income_state.dart';

class GoldIncomeBloc extends Bloc<GoldIncomeEvent, GoldIncomeState> {
  final GetGoldIncomeUc getGoldIncomeUc;

  GoldIncomeBloc({required this.getGoldIncomeUc})
      : super(GoldIncomeInitialState()) {
    on<GoldIncomeEvent>((event, emit) async {
      emit(GoldIncomeLoadingState());
      final result = await getGoldIncomeUc();
      result.fold(
        (l) => emit(GoldIncomeFailureState(l, l.code, l.messages)),
        (r) => emit(GoldIncomeSuccessState(r)),
      );
    });
  }
}
