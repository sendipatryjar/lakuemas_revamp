import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'physical_pull_withdrawal_method_state.dart';

class PhysicalPullWithdrawalMethodCubit extends Cubit<int?> {
  PhysicalPullWithdrawalMethodCubit() : super(null);

  void changeOptionTakeShop(int? index) {
    emit(index);
  }

  void changeOption(int? index) {
    emit(index);
  }
}
