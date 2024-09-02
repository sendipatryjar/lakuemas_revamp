part of 't_and_c_register_bloc.dart';

sealed class TAndCRegisterEvent extends Equatable {
  const TAndCRegisterEvent();

  @override
  List<Object> get props => [];
}

class TAndCRegisterGetEvent extends TAndCRegisterEvent {}
