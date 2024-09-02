part of 'subscription_packages_bloc.dart';

abstract class SubscriptionPackagesState extends Equatable {
  const SubscriptionPackagesState();

  @override
  List<Object> get props => [];
}

class SubscriptionPackagesInitial extends SubscriptionPackagesState {}

class SubscriptionPackagesLoadingState extends SubscriptionPackagesState {}

class SubscriptionPackagesSuccessState extends SubscriptionPackagesState {
  final List<SubscriptionPackagesEntity> subscriptionPackagesEntity;

  const SubscriptionPackagesSuccessState(this.subscriptionPackagesEntity);

  @override
  List<Object> get props => [
        [subscriptionPackagesEntity]
      ];
}

class SubscriptionPackagesFailureState extends SubscriptionPackagesState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SubscriptionPackagesFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
