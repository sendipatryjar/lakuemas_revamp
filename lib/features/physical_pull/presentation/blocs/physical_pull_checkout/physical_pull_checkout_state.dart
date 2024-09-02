part of 'physical_pull_checkout_bloc.dart';

abstract class PhysicalPullCheckoutState extends Equatable {
  const PhysicalPullCheckoutState();

  @override
  List<Object> get props => [];
}

class PhysicalPullCheckoutInitialState extends PhysicalPullCheckoutState {}

class PhysicalPullCheckoutLoadingState extends PhysicalPullCheckoutState {}

class PhysicalPullCheckoutSuccessState extends PhysicalPullCheckoutState {
  final PhysicalPullCheckoutEntity physicalPullCheckoutEntity;

  const PhysicalPullCheckoutSuccessState(this.physicalPullCheckoutEntity);

  @override
  List<Object> get props => [physicalPullCheckoutEntity];
}

class PhysicalPullCheckoutFailureState extends PhysicalPullCheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PhysicalPullCheckoutFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
