part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPressed extends RegisterEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;

  const RegisterPressed({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });
}
