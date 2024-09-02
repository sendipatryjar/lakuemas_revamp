part of 'support_contact_bloc.dart';

abstract class SupportContactEvent extends Equatable {
  const SupportContactEvent();

  @override
  List<Object> get props => [];
}

class SupportContactGetEvent extends SupportContactEvent {}
