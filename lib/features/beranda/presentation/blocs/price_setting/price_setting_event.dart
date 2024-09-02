part of 'price_setting_bloc.dart';

abstract class PriceSettingEvent extends Equatable {
  final dynamic data;
  const PriceSettingEvent(this.data);

  @override
  List<Object> get props => [data];
}

class PriceSettingGetEvent extends PriceSettingEvent {
  final HelperDataCubit helperDataCubit;
  final bool isNeedRefresh;

  const PriceSettingGetEvent(
      {required this.helperDataCubit, this.isNeedRefresh = false})
      : super(helperDataCubit);
}
