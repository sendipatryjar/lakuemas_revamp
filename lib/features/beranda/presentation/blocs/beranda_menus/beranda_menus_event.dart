part of 'beranda_menus_bloc.dart';

abstract class BerandaMenusEvent extends Equatable {
  final dynamic data;
  const BerandaMenusEvent(this.data);

  @override
  List<Object> get props => [data];
}

class BerandaMenusGetEvent extends BerandaMenusEvent {
  final HelperDataCubit? helperDataCubit;

  const BerandaMenusGetEvent({this.helperDataCubit}) : super(helperDataCubit);
}
