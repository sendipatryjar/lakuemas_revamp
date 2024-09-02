import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/constants/secure_storage_key.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/services/secure_storage_service.dart';
import '../../../../_core/user/data/models/user_data_model.dart';
import '../../../../_core/user/domain/entities/user_data_entity.dart';
import '../../../domain/entities/lakusave_duration_entity.dart';
import '../../../domain/entities/lakusave_extend_entity.dart';
import '../../../domain/entities/lakusave_interest_entity.dart';

part 'lakusave_state.dart';

class LakusaveCubit extends Cubit<LakusaveState> {
  LakusaveCubit() : super(const LakusaveState());

  bool isValidated(double? minimumBalance, double currBalance) {
    return isBalanceValidated(state.goldAmount, minimumBalance, currBalance) &&
        (state.selectedDurationEntity != null);
  }

  bool isBalanceValidated(
    double? goldAmount,
    double? minimumBalance,
    double currBalance,
  ) {
    return ((goldAmount ?? 0) >= (minimumBalance ?? 0)) &&
        ((goldAmount ?? 0) <= currBalance);
  }

  void refillState(LakusaveState data) => emit(data);

  void getUserData() async {
    final userMapString =
        await sl<SecureStorageService>().readSecureData(ssUserData);
    var aaa = jsonDecode(userMapString ?? '');
    var userData = UserDataModel.fromJson(aaa);
    emit(state.copyWith(userDataEntity: userData));
  }

  void changeExtended(LakusaveExtendEntity? value) => emit(state.copyWith(
        selectedExtendedEntity: value,
        isNullifySelectedExtended: value == null,
      ));

  void changeDuration({
    required LakusaveDurationEntity value,
    List<LakusaveInterestEntity> interests = const [],
    int? customerTypeId,
    double? goldAmount,
    double? userGoldBalance,
    bool isElite = false,
  }) {
    emit(state.copyWith(selectedDurationEntity: value));
    selectInterest(
      interests: interests,
      customerTypeId: customerTypeId,
      durationId: value.id,
      goldAmount: goldAmount,
      userGoldBalance: userGoldBalance,
      isElite: isElite,
    );
  }

  void selectInterest({
    List<LakusaveInterestEntity> interests = const [],
    int? customerTypeId,
    int? durationId,
    double? goldAmount,
    double? minGoldAmount,
    double? userGoldBalance,
    bool isElite = false,
  }) {
    List<LakusaveInterestEntity> helperInterests = [];
    helperInterests.addAll(interests);
    List<LakusaveInterestEntity> filteredInterests = [];
    filteredInterests.addAll(helperInterests.where(
      (element) {
        double? minBalance =
            isElite ? element.eliteMinimumBalance : element.minimumBalance;
        return element.customerTypeId == customerTypeId &&
            element.depositDurationId == durationId &&
            (goldAmount ?? 0) >= (minBalance ?? 0) &&
            (goldAmount ?? 0) <= (element.maximumBalance ?? 0);
      },
    ).toList());
    bool isNullify = filteredInterests.isEmpty;
    emit(state.copyWith(
      goldAmount: goldAmount,
      isErrorGoldAmount: isBalanceValidated(
            goldAmount,
            minGoldAmount,
            userGoldBalance ?? 0,
          ) ==
          false,
      selectedInterestEntity:
          filteredInterests.isNotEmpty ? filteredInterests.first : null,
      isNullifySelectedInterest: isNullify,
      isAmountMoreThanBalance: (goldAmount ?? 0) > (userGoldBalance ?? 0),
    ));
  }
}
