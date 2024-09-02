import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/secure_storage_key.dart';
import '../../../depedencies_injection/depedency_injection.dart';
import '../../secure_storage_service.dart';

class EliteCubit extends Cubit<bool> {
  EliteCubit() : super(false);

  void init(String? isEliteMode) async {
    String? isElite = isEliteMode;

    isElite ??= await sl<SecureStorageService>().readSecureData(ssIsElite);

    emit(isElite == 'true');
    // emit(false);
  }

  void change(bool isElite) {
    emit(isElite);
    //
    // emit(true);
  }
}
