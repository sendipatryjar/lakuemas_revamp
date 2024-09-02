part of 'update_settings_bloc.dart';

abstract class UpdateSettingsEvent extends Equatable {
  const UpdateSettingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateSettingsPressed extends UpdateSettingsEvent {
  final bool withPrice;
  final bool withPromo;

  const UpdateSettingsPressed({
    required this.withPrice,
    required this.withPromo,
  });

  @override
  List<Object> get props => [withPrice, withPromo];
}
