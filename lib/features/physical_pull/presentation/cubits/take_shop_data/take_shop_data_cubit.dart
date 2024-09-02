import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../profile/domain/entities/city_entity.dart';
import '../../../../profile/domain/entities/province_entity.dart';

part 'take_shop_data_state.dart';

class TakeShopDataCubit extends Cubit<TakeShopDataState> {
  TakeShopDataCubit() : super(const TakeShopDataState());

  void changeProvince(ProvinceEntity? value) {
    emit(state.copyWith(provinceEntity: value));
  }

  void changeCity(CityEntity? value) {
    emit(state.copyWith(cityEntity: value));
  }

  void getDataEvent(
    int? storeId,
    int? courierPriceId,
    String? destinationAddress,
    String? deliveryMethod,
  ) {
    emit(state.copyWith(
      storeId: storeId,
      courierPriceId: courierPriceId,
      destinationAddress: destinationAddress,
      deliveryMethod: deliveryMethod,
    ));
  }
}
