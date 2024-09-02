part of 'beranda_menus_bloc.dart';

abstract class BerandaMenusState extends Equatable {
  const BerandaMenusState();

  @override
  List<Object> get props => [];
}

class BerandaMenusInitialState extends BerandaMenusState {}

class BerandaMenusLoadingState extends BerandaMenusState {}

class BerandaMenusSuccessState extends BerandaMenusState {
  final List<MenuEntity> menuPrimary;
  final List<MenuEntity> menuSecondary;
  final List<MenuEntity> allMenu;

  const BerandaMenusSuccessState({
    required this.menuPrimary,
    required this.menuSecondary,
    required this.allMenu,
  });

  @override
  List<Object> get props => [
        [menuPrimary, menuPrimary]
      ];
}

class BerandaMenusFailureState extends BerandaMenusState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BerandaMenusFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
