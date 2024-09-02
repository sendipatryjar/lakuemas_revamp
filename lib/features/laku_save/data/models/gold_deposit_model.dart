import '../../domain/entities/gold_deposit_entity.dart';
import 'lakusave_duration_model.dart';
import 'lakusave_extend_model.dart';
import 'lakusave_interest_model.dart';
import '../../../_core/others/data/models/terms_and_conditions_model.dart';

class GoldDepositModel extends GoldDepositEntity {
  const GoldDepositModel({
    String? minimumBalance,
    String? eliteMinimumBalance,
    TermsAndConditionsModel? termsAndConditionsEntity,
    List<LakusaveDurationModel> durations = const [],
    List<LakusaveExtendModel> extendss = const [],
    List<LakusaveInterestModel> interests = const [],
  }) : super(
          minimumBalance: minimumBalance,
          eliteMinimumBalance: eliteMinimumBalance,
          termsAndConditionsEntity: termsAndConditionsEntity,
          durations: durations,
          extendss: extendss,
          interests: interests,
        );

  static GoldDepositModel fromJson(Map<String, dynamic> json) {
    List<LakusaveDurationModel> lksvDurations = [];
    if (json['durations'] != null) {
      lksvDurations = <LakusaveDurationModel>[];
      json['durations'].forEach((v) {
        lksvDurations.add(LakusaveDurationModel.fromJson(v));
      });
    }
    List<LakusaveExtendModel> lksvExtends = [];
    if (json['extends'] != null) {
      lksvExtends = <LakusaveExtendModel>[];
      json['extends'].forEach((v) {
        lksvExtends.add(LakusaveExtendModel.fromJson(v));
      });
    }
    List<LakusaveInterestModel> lksvInterests = [];
    if (json['interests'] != null) {
      lksvInterests = <LakusaveInterestModel>[];
      json['interests'].forEach((v) {
        lksvInterests.add(LakusaveInterestModel.fromJson(v));
      });
    }
    return GoldDepositModel(
      minimumBalance: json['minimum_balance'],
      eliteMinimumBalance: json['elite_minimum_balance'],
      termsAndConditionsEntity: json['term_and_conditions'] != null
          ? TermsAndConditionsModel.fromJson(json['term_and_conditions'])
          : null,
      durations: lksvDurations,
      extendss: lksvExtends,
      interests: lksvInterests,
    );
  }
}
