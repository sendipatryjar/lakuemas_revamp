import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'select_payment_state.dart';

class SelectPaymentCubit extends Cubit<int?> {
  SelectPaymentCubit() : super(null);

  void changeOption(int? paymentMethodId) {
    emit(paymentMethodId);
  }
}
