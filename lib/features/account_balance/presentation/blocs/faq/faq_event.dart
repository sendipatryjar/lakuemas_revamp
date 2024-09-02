part of 'faq_bloc.dart';

abstract class AccountBalanceFaqEvent extends Equatable {
  const AccountBalanceFaqEvent();

  @override
  List<Object> get props => [];
}

class AccountBalanceFaqGetEvent extends AccountBalanceFaqEvent {}
