part of 'privacy_policy_register_bloc.dart';

sealed class PrivacyPolicyRegisterState extends Equatable {
  const PrivacyPolicyRegisterState();

  @override
  List<Object> get props => [];
}

class PrivacyPolicyRegisterInitialState extends PrivacyPolicyRegisterState {}

class PrivacyPolicyRegisterLoadingState extends PrivacyPolicyRegisterState {}

class PrivacyPolicyRegisterSuccessState extends PrivacyPolicyRegisterState {
  final String? htmlStr;

  const PrivacyPolicyRegisterSuccessState({
    required this.htmlStr,
  });

  @override
  List<Object> get props => [
        [htmlStr],
      ];
}

class PrivacyPolicyRegisterFailureState extends PrivacyPolicyRegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PrivacyPolicyRegisterFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
