import '../../domain/entities/chart_duration_entity.dart';
import 'chart_model.dart';

class ChartDurationModel extends ChartDurationEntity {
  const ChartDurationModel({
    List<ChartModel> sevenDaysAgo = const [],
    List<ChartModel> oneMonthAgo = const [],
    List<ChartModel> threeMonthsAgo = const [],
    List<ChartModel> sixMonthsAgo = const [],
  }) : super(
          sevenDaysAgo: sevenDaysAgo,
          oneMonthAgo: oneMonthAgo,
          threeMonthsAgo: threeMonthsAgo,
          sixMonthsAgo: sixMonthsAgo,
        );

  factory ChartDurationModel.fromJson(Map<String, dynamic> json) {
    List<ChartModel> sevenDays = [];
    if (json['seven_days_ago'] != null) {
      json['seven_days_ago'].forEach((v) {
        sevenDays.add(ChartModel.fromJson(v));
      });
    }

    List<ChartModel> oneMonth = [];
    if (json['one_month_ago'] != null) {
      json['one_month_ago'].forEach((v) {
        oneMonth.add(ChartModel.fromJson(v));
      });
    }

    List<ChartModel> threeMonth = [];
    if (json['three_months_ago'] != null) {
      json['three_months_ago'].forEach((v) {
        threeMonth.add(ChartModel.fromJson(v));
      });
    }

    List<ChartModel> sixMonth = [];
    if (json['six_months_ago'] != null) {
      json['six_months_ago'].forEach((v) {
        sixMonth.add(ChartModel.fromJson(v));
      });
    }

    return ChartDurationModel(
      sevenDaysAgo: sevenDays,
      oneMonthAgo: oneMonth,
      threeMonthsAgo: threeMonth,
      sixMonthsAgo: sixMonth,
    );
  }

  Map<String, dynamic> toJson() => {
        'seven_days_ago': sevenDaysAgo
            .map((v) => ChartModel(
                  purchasePrice: v.purchaseePrice,
                  sellingPrice: v.sellingPrice,
                  activeDate: v.activeDate,
                ).toJson())
            .toList(),
        'one_month_ago': oneMonthAgo
            .map((v) => ChartModel(
                  purchasePrice: v.purchaseePrice,
                  sellingPrice: v.sellingPrice,
                  activeDate: v.activeDate,
                ).toJson())
            .toList(),
        'three_months_ago': threeMonthsAgo
            .map((v) => ChartModel(
                  purchasePrice: v.purchaseePrice,
                  sellingPrice: v.sellingPrice,
                  activeDate: v.activeDate,
                ).toJson())
            .toList(),
        'six_months_ago': sixMonthsAgo
            .map((v) => ChartModel(
                  purchasePrice: v.purchaseePrice,
                  sellingPrice: v.sellingPrice,
                  activeDate: v.activeDate,
                ).toJson())
            .toList(),
      };
}
