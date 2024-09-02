part of 'take_shop_data_cubit.dart';

class TakeShopDataState extends Equatable {
  final ProvinceEntity? provinceEntity;
  final CityEntity? cityEntity;
  final int? storeId;
  final int? courierPriceId;
  final String? destinationAddress;
  final String? deliveryMethod;

  const TakeShopDataState({
    this.provinceEntity,
    this.cityEntity,
    this.storeId,
    this.courierPriceId,
    this.destinationAddress,
    this.deliveryMethod,
  });

  TakeShopDataState copyWith({
    ProvinceEntity? provinceEntity,
    CityEntity? cityEntity,
    int? storeId,
    String? destinationAddress,
    String? deliveryMethod,
    int? courierPriceId,
  }) =>
      TakeShopDataState(
        provinceEntity: provinceEntity ?? this.provinceEntity,
        cityEntity: cityEntity ?? this.cityEntity,
        storeId: storeId ?? this.storeId,
        destinationAddress: destinationAddress ?? this.destinationAddress,
        deliveryMethod: deliveryMethod ?? this.deliveryMethod,
        courierPriceId: courierPriceId ?? this.courierPriceId,
      );

  @override
  List<Object?> get props => [
        provinceEntity,
        cityEntity,
        storeId,
        courierPriceId,
        destinationAddress,
        deliveryMethod,
      ];
}
