part of 'support_contact_bloc.dart';

abstract class SupportContactState extends Equatable {
  const SupportContactState();

  @override
  List<Object> get props => [];
}

class SupportContactInitialState extends SupportContactState {}

class SupportContactLoadingState extends SupportContactState {}

class SupportContactSuccessState extends SupportContactState {
  final String? email;
  final String? phone;

  const SupportContactSuccessState({this.email, this.phone});

  @override
  List<Object> get props => [
        [email, phone]
      ];
}

class SupportContactFailureState extends SupportContactState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SupportContactFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
