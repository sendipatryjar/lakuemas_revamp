import 'package:equatable/equatable.dart';

class PortofolioEntity extends Equatable {
  final double? totalWeight;
  final int? totalNominal;
  final int? potentialGainNominal;
  final double? potentialGainPercentage;
  final DepositEntity? savings;
  final DepositEntity? deposit;
  final DepositEntity? elite;

  const PortofolioEntity({
    this.totalWeight,
    this.totalNominal,
    this.potentialGainNominal,
    this.potentialGainPercentage,
    this.savings,
    this.deposit,
    this.elite,
  });

  @override
  List<Object?> get props => [
        totalWeight,
        totalNominal,
        potentialGainNominal,
        potentialGainPercentage,
        savings,
        deposit,
        elite,
      ];
}

class DepositEntity extends Equatable {
  final String? weight;
  final String? nominal;
  final String? marketNominal;
  final String? percentageIncrease;
  final String? percentage;
  final String? totalCount;
  final String? referralIncreaseCount;

  const DepositEntity({
    this.weight,
    this.nominal,
    this.marketNominal,
    this.percentageIncrease,
    this.percentage,
    this.totalCount,
    this.referralIncreaseCount,
  });

  @override
  List<Object?> get props => [
        weight,
        nominal,
        marketNominal,
        percentageIncrease,
        percentage,
        totalCount,
        referralIncreaseCount,
      ];
}
