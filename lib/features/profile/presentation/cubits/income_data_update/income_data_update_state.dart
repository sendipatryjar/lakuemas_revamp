part of 'income_data_update_cubit.dart';

class IncomeDataUpdateState extends Equatable {
  final String? occupation;
  final String? income;
  final String? purpose;
  //
  final String? occupationErrMessage;
  final String? incomeErrMessage;
  final String? purposeErrMessage;

  const IncomeDataUpdateState({
    this.occupation,
    this.income,
    this.purpose,
    //
    this.occupationErrMessage,
    this.incomeErrMessage,
    this.purposeErrMessage,
  });

  IncomeDataUpdateState copyWith({
    String? occupation,
    String? income,
    String? purpose,
    //
    String? occupationErrMessage,
    String? incomeErrMessage,
    String? purposeErrMessage,
  }) =>
      IncomeDataUpdateState(
        occupation: occupation ?? this.occupation,
        income: income ?? this.income,
        purpose: purpose ?? this.purpose,
        //
        occupationErrMessage: occupationErrMessage ?? this.occupationErrMessage,
        incomeErrMessage: incomeErrMessage ?? this.incomeErrMessage,
        purposeErrMessage: purposeErrMessage ?? this.purposeErrMessage,
      );

  @override
  List<Object> get props => [
        [
          occupation,
          income,
          purpose,
          //
          occupationErrMessage,
          incomeErrMessage,
          purposeErrMessage,
        ]
      ];
}
