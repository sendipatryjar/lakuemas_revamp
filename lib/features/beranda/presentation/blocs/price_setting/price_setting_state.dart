part of 'price_setting_bloc.dart';

abstract class PriceSettingState extends Equatable {
  const PriceSettingState();

  @override
  List<Object> get props => [];
}

class PriceSettingInitialState extends PriceSettingState {}

class PriceSettingLoadingState extends PriceSettingState {}

class PriceSettingSuccessState extends PriceSettingState {
  final PriceEntity priceEntity;

  const PriceSettingSuccessState({
    required this.priceEntity,
  });

  @override
  List<Object> get props => [
        [priceEntity]
      ];
}

class PriceSettingFailureState extends PriceSettingState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PriceSettingFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
