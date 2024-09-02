part of 'cash_withdrawal_cubit.dart';

class CashWithdrawalState extends Equatable {
  final double? minDenom;
  final double? fee;
  final bool? isSelected;
  final bool? isNominalError;
  final String? isNominalErrorMessages;
  final BankMeEntity? bankMeEntity;
  const CashWithdrawalState({
    this.minDenom,
    this.fee,
    this.isSelected,
    this.isNominalError,
    this.isNominalErrorMessages,
    this.bankMeEntity,
  });

  CashWithdrawalState copyWith({
    double? minDenom,
    double? fee,
    bool? isSelected,
    bool? isNominalError,
    String? isNominalErrorMessages,
    BankMeEntity? bankMeEntity,
  }) =>
      CashWithdrawalState(
        minDenom: minDenom ?? this.minDenom,
        fee: fee ?? this.fee,
        isSelected: isSelected ?? this.isSelected,
        isNominalError: isNominalError ?? this.isNominalError,
        isNominalErrorMessages:
            isNominalErrorMessages ?? this.isNominalErrorMessages,
        bankMeEntity: bankMeEntity ?? this.bankMeEntity,
      );

  @override
  List<Object> get props => [
        [
          minDenom,
          fee,
          isSelected,
          isNominalError,
          isNominalErrorMessages,
          bankMeEntity
        ]
      ];
}
