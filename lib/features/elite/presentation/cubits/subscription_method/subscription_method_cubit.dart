import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subscription_method_state.dart';

class SubscriptionMethodCubit extends Cubit<int?> {
  SubscriptionMethodCubit() : super(null);

  void changeOption(int? index) {
    emit(index);
  }
}
