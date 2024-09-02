part of 'privacy_policy_register_bloc.dart';

sealed class PrivacyPolicyRegisterEvent extends Equatable {
  const PrivacyPolicyRegisterEvent();

  @override
  List<Object> get props => [];
}

class PrivacyPolicyRegisterGetEvent extends PrivacyPolicyRegisterEvent {}
