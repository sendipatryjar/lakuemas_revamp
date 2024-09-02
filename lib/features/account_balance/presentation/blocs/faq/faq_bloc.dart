import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/account_balance_faq_entity.dart';
import '../../../domain/usecases/get_faq_uc.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class AccountBalanceFaqBloc extends Bloc<AccountBalanceFaqEvent, AccountBalanceFaqState> {
  final GetFaqUc getFaqUc;

  AccountBalanceFaqBloc({required this.getFaqUc}) : super(AccountBalanceFaqInitialState()) {
    on<AccountBalanceFaqGetEvent>((event, emit) async {
      emit(AccountBalanceFaqLoadingState());
      final result = await getFaqUc();
      result.fold(
        (l) => emit(AccountBalanceFaqFailureState(l, l.code, l.messages)),
        (r) => emit(AccountBalanceFaqSuccessState(accountBalanceFaqs: r)),
      );
    });
  }
}
