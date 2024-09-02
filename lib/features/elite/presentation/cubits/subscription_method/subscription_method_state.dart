part of 'subscription_method_cubit.dart';

class SubscriptionMethodState extends Equatable {
  final Object? index;

  const SubscriptionMethodState({this.index});

  SubscriptionMethodState copyWith({
    Object? index,
  }) =>
      SubscriptionMethodState(
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [
        index,
      ];
}
