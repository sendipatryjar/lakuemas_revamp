part of 'faq_bloc.dart';

abstract class AccountBalanceFaqState extends Equatable {
  const AccountBalanceFaqState();

  @override
  List<Object> get props => [];
}

class AccountBalanceFaqInitialState extends AccountBalanceFaqState {}

class AccountBalanceFaqLoadingState extends AccountBalanceFaqState {}

class AccountBalanceFaqSuccessState extends AccountBalanceFaqState {
  final List<AccountBalanceFaqEntity> accountBalanceFaqs;

  const AccountBalanceFaqSuccessState({
    required this.accountBalanceFaqs,
  });

  @override
  List<Object> get props => [
        [accountBalanceFaqs]
      ];
}

class AccountBalanceFaqFailureState extends AccountBalanceFaqState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const AccountBalanceFaqFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
