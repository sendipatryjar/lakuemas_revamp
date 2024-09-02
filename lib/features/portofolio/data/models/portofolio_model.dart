import '../../../../features/portofolio/domain/entities/portofolio_entity.dart';

class PortofolioModel extends PortofolioEntity {
  const PortofolioModel({
    double? totalWeight,
    int? totalNominal,
    int? potentialGainNominal,
    double? potentialGainPercentage,
    DepositEntity? savings,
    DepositEntity? deposit,
    DepositEntity? elite,
  }) : super(
          totalWeight: totalWeight,
          totalNominal: totalNominal,
          potentialGainNominal: potentialGainNominal,
          potentialGainPercentage: potentialGainPercentage,
          savings: savings,
          deposit: deposit,
          elite: elite,
        );

  static PortofolioModel fromJson(Map<String, dynamic> json) => PortofolioModel(
        totalWeight: json["total_weight"] is String
            ? double.tryParse(json["total_weight"])
            : json["total_weight"] is int
                ? json["total_weight"].toDouble()
                : json["total_weight"],
        totalNominal: json["total_nominal"] is String
            ? int.tryParse(json["total_nominal"])
            : json["total_nominal"],
        potentialGainNominal: json["potential_gain_nominal"] is String
            ? int.tryParse(json["potential_gain_nominal"])
            : json["potential_gain_nominal"],
        potentialGainPercentage: json["potential_gain_percentage"] is String
            ? double.tryParse(json["potential_gain_percentage"])
            : json["potential_gain_percentage"] is int
                ? json["potential_gain_percentage"].toDouble()
                : json["potential_gain_percentage"],
        savings: json["savings"] == null
            ? null
            : DepositEntityModel.fromJson(json["savings"]),
        deposit: json["deposit"] == null
            ? null
            : DepositEntityModel.fromJson(json["deposit"]),
        elite: json["elite"] == null
            ? null
            : DepositEntityModel.fromJson(json["elite"]),
      );

  Map<String, dynamic> toJson() => {
        "total_weight": totalWeight,
        "total_nominal": totalNominal,
        "potential_gain_nominal": potentialGainNominal,
        "potential_gain_percentage": potentialGainPercentage,
        "savings": savings,
        "deposit": deposit,
        "elite": elite,
      };
}

class DepositEntityModel extends DepositEntity {
  const DepositEntityModel({
    String? weight,
    String? nominal,
    String? marketNominal,
    String? percentageIncrease,
    String? percentage,
    String? totalCount,
    String? referralIncreaseCount,
  }) : super(
            weight: weight,
            nominal: nominal,
            marketNominal: marketNominal,
            percentageIncrease: percentageIncrease,
            percentage: percentage,
            totalCount: totalCount,
            referralIncreaseCount: referralIncreaseCount);

  static DepositEntityModel fromJson(Map<String, dynamic> json) =>
      DepositEntityModel(
        weight: json["weight"],
        nominal: json["nominal"],
        marketNominal: json["market_nominal"],
        percentageIncrease: json["percentage_increase"],
        percentage: json["percentage"],
        totalCount: json["total_count"],
        referralIncreaseCount: json["referral_increase_count"],
      );

  Map<String, dynamic> toJson() => {
        "weight": weight,
        "nominal": nominal,
        "market_nominal": marketNominal,
        "percentage_increase": percentageIncrease,
        "percentage": percentage,
        "total_count": totalCount,
        "referral_increase_count": referralIncreaseCount,
      };
}
