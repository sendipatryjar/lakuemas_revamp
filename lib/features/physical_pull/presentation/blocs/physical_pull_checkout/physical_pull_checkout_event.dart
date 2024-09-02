part of 'physical_pull_checkout_bloc.dart';

abstract class PhysicalPullCheckoutEvent extends Equatable {
  const PhysicalPullCheckoutEvent();

  @override
  List<Object> get props => [];
}

class PhysicalPullCheckoutGetEvent extends PhysicalPullCheckoutEvent {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;

  const PhysicalPullCheckoutGetEvent(this.physicalPullCheckoutReq);

  @override
  List<Object> get props => [
        [physicalPullCheckoutReq]
      ];
}
