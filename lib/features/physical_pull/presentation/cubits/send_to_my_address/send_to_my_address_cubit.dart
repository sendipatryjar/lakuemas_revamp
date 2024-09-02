import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'send_to_my_address_state.dart';

class SendToMyAddressCubit extends Cubit<int?> {
  SendToMyAddressCubit() : super(null);

  void changeOption(int? index) {
    emit(index);
  }
}
