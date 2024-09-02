part of 'subscription_packages_cubit.dart';

class SubscriptionPackagesStateCubit extends Equatable {
  final int? index;
  final double? totGrammation;

  const SubscriptionPackagesStateCubit({
    this.index,
    this.totGrammation,
  });

  SubscriptionPackagesStateCubit copyWith({
    int? index,
    double? totGrammation,
  }) =>
      SubscriptionPackagesStateCubit(
        index: index ?? this.index,
        totGrammation: totGrammation ?? this.totGrammation,
      );

  @override
  List<Object?> get props => [
        index,
        totGrammation,
      ];
}
