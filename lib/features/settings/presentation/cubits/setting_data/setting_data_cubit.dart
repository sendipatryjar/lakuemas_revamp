import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_core/user/domain/entities/user_setting_entity.dart';
import '../../../../profile/domain/usecases/get_user_data_uc.dart';

part 'setting_data_state.dart';

class SettingDataCubit extends Cubit<SettingDataState> {
  final GetUserDataUc getUserDataUc;
  SettingDataCubit({required this.getUserDataUc})
      : super(const SettingDataState(
          currentData: UserSettingEntity(
            withPrice: true,
            withPromo: true,
          ),
          priceNotif: true,
          promoNotif: true,
        ));

  void init() async {
    final result = await getUserDataUc(isFromLocal: true);
    final data = result.getOrElse(() => null);
    updateSetting(
      currentData: data?.userSettingEntity,
      priceNotif: data?.userSettingEntity?.withPrice,
      promoNotif: data?.userSettingEntity?.withPromo,
    );
  }

  void updateSetting({
    UserSettingEntity? currentData,
    bool? priceNotif,
    bool? promoNotif,
  }) =>
      emit(state.copyWith(
        currentData: currentData,
        priceNotif: priceNotif ?? state.priceNotif,
        promoNotif: promoNotif ?? state.promoNotif,
      ));
}
