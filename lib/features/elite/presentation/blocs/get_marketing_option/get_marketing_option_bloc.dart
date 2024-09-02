import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/get_marketing_option_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'get_marketing_option_event.dart';
part 'get_marketing_option_state.dart';

class GetMarketingOptionBloc
    extends Bloc<GetMarketingOptionEvent, GetMarketingOptionState> {
  final GetMarketingOptionUc getMarketingOptionUc;

  GetMarketingOptionBloc({required this.getMarketingOptionUc})
      : super(GetMarketingOptionInitial()) {
    on<GetMarketingOptionEvents>((event, emit) async {
      if (event.helperDataEliteCubit.state.getMarketingOptionEntity != null) {
        emit(GetMarketingSuccessState(
            event.helperDataEliteCubit.state.getMarketingOptionEntity!));
        return;
      }
      emit(GetMarketingOptionLoadingState());
      final result = await getMarketingOptionUc();
      result.fold(
        (l) => emit(GetMarketingFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateGetMarketingOptionEntity(r);
          emit(GetMarketingSuccessState(r));
        },
      );
    });
  }
}
