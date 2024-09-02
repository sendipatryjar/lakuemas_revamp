part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterEntity registerEntity;

  const RegisterSuccess(this.registerEntity);

  @override
  List<Object> get props => [registerEntity];
}

class RegisterFailure extends RegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const RegisterFailure(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
