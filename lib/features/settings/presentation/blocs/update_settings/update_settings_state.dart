part of 'update_settings_bloc.dart';

abstract class UpdateSettingsState extends Equatable {
  const UpdateSettingsState();

  @override
  List<Object> get props => [];
}

class UpdateSettingsInitialState extends UpdateSettingsState {}

class UpdateSettingsLoadingState extends UpdateSettingsState {}

class UpdateSettingsSuccessState extends UpdateSettingsState {
  final bool withPrice;
  final bool withPromo;

  const UpdateSettingsSuccessState({
    required this.withPrice,
    required this.withPromo,
  });

  @override
  List<Object> get props => [withPrice, withPromo];
}

class UpdateSettingsFailureState extends UpdateSettingsState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const UpdateSettingsFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
