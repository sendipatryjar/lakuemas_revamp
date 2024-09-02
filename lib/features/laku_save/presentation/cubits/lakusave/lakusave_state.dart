part of 'lakusave_cubit.dart';

class LakusaveState extends Equatable {
  final double? goldAmount;
  final bool? isErrorGoldAmount;
  final LakusaveDurationEntity? selectedDurationEntity;
  final LakusaveInterestEntity? selectedInterestEntity;
  final LakusaveExtendEntity? selectedExtendedEntity;
  final UserDataEntity? userDataEntity;
  final bool isAmountMoreThanBalance;

  const LakusaveState({
    this.goldAmount,
    this.isErrorGoldAmount,
    this.selectedDurationEntity,
    this.selectedInterestEntity,
    this.selectedExtendedEntity,
    this.userDataEntity,
    this.isAmountMoreThanBalance = false,
  });

  LakusaveState copyWith({
    double? goldAmount,
    bool? isErrorGoldAmount,
    LakusaveDurationEntity? selectedDurationEntity,
    LakusaveInterestEntity? selectedInterestEntity,
    bool isNullifySelectedInterest = false,
    LakusaveExtendEntity? selectedExtendedEntity,
    bool isNullifySelectedExtended = false,
    UserDataEntity? userDataEntity,
    bool? isAmountMoreThanBalance,
  }) =>
      LakusaveState(
        goldAmount: goldAmount ?? this.goldAmount,
        isErrorGoldAmount: isErrorGoldAmount ?? this.isErrorGoldAmount,
        selectedDurationEntity:
            selectedDurationEntity ?? this.selectedDurationEntity,
        selectedInterestEntity: isNullifySelectedInterest
            ? null
            : (selectedInterestEntity ?? this.selectedInterestEntity),
        selectedExtendedEntity: isNullifySelectedExtended
            ? null
            : (selectedExtendedEntity ?? this.selectedExtendedEntity),
        userDataEntity: userDataEntity ?? this.userDataEntity,
        isAmountMoreThanBalance:
            isAmountMoreThanBalance ?? this.isAmountMoreThanBalance,
      );

  @override
  List<Object?> get props => [
        goldAmount,
        selectedDurationEntity,
        selectedInterestEntity,
        selectedExtendedEntity,
        userDataEntity
      ];
}
