part of 'subscription_packages_bloc.dart';

abstract class SubscriptionPackagesEvent extends Equatable {
  const SubscriptionPackagesEvent();

  @override
  List<Object> get props => [];
}

class GetSubscriptionPackagesEvent extends SubscriptionPackagesEvent {}
