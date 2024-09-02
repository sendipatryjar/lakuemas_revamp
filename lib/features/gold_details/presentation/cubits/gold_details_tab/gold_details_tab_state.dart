part of 'gold_details_tab_cubit.dart';

enum EnGoldDetails { goldDetails, yourIncome }

class GoldDetailsTabState extends Equatable {
  final EnGoldDetails enGoldDetails;
  const GoldDetailsTabState({required this.enGoldDetails});

  GoldDetailsTabState copyWith({
    EnGoldDetails? enGoldDetails,
  }) =>
      GoldDetailsTabState(
        enGoldDetails: enGoldDetails ?? this.enGoldDetails,
      );

  @override
  List<Object?> get props => [enGoldDetails];
}
