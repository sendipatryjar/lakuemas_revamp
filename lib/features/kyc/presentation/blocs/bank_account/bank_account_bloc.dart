import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/bank_account_uc.dart';

part 'bank_account_event.dart';
part 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  final BankAccountUc bankAccountUc;
  BankAccountBloc({required this.bankAccountUc}) : super(BankAccountInitial()) {
    on<BankAccountKycPressedEvent>((event, emit) async {
      emit(BankAccountLoadingState());
      final result = await bankAccountUc(
        event.accountNumber,
        event.bankId,
      );

      result.fold(
        (l) => emit(BankAccountFailureState(l.code, l.messages)),
        (r) => emit(BankAccountSuccessState()),
      );
    });
  }
}
