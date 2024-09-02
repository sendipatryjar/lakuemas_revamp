import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordObsecureCubit extends Cubit<bool> {
  PasswordObsecureCubit() : super(true);

  void changeObsecure(bool value) => emit(value);
}
