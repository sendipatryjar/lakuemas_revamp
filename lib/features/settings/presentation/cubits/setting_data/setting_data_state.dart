part of 'setting_data_cubit.dart';

class SettingDataState extends Equatable {
  final UserSettingEntity currentData;
  final bool priceNotif;
  final bool promoNotif;

  const SettingDataState({
    required this.currentData,
    required this.priceNotif,
    required this.promoNotif,
  });

  SettingDataState copyWith({
    UserSettingEntity? currentData,
    bool? priceNotif,
    bool? promoNotif,
  }) =>
      SettingDataState(
        currentData: currentData ?? this.currentData,
        priceNotif: priceNotif ?? this.priceNotif,
        promoNotif: promoNotif ?? this.promoNotif,
      );

  @override
  List<Object> get props => [currentData, priceNotif, promoNotif];
}
