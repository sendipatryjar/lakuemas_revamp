part of 'transfer_validation_cubit.dart';

class TransferValidationState extends Equatable {
  final bool? isTotalGoldError;
  final String? totalGoldErrorMessages;
  final bool? isNoRekeningError;
  final String? noRekeningErrorMessages;
  final EnTransfer? enTransfer;
  const TransferValidationState({
    this.isTotalGoldError,
    this.totalGoldErrorMessages,
    this.isNoRekeningError,
    this.noRekeningErrorMessages,
    this.enTransfer = EnTransfer.newAccount,
  });

  TransferValidationState copyWith({
    bool? isTotalGoldError,
    String? totalGoldErrorMessages,
    bool nullifyTotalGoldError = false,
    bool? isNoRekeningError,
    String? noRekeningErrorMessages,
    bool nullifyRekeningError = false,
    EnTransfer? enTransfer,
  }) =>
      TransferValidationState(
        isTotalGoldError: nullifyTotalGoldError
            ? false
            : (isTotalGoldError ?? this.isTotalGoldError),
        totalGoldErrorMessages: nullifyTotalGoldError
            ? null
            : (totalGoldErrorMessages ?? this.totalGoldErrorMessages),
        isNoRekeningError: nullifyRekeningError
            ? false
            : (isNoRekeningError ?? this.isNoRekeningError),
        noRekeningErrorMessages: nullifyRekeningError
            ? null
            : (noRekeningErrorMessages ?? this.noRekeningErrorMessages),
        enTransfer: enTransfer ?? this.enTransfer,
      );

  @override
  List<Object> get props => [
        [
          isTotalGoldError,
          totalGoldErrorMessages,
          isNoRekeningError,
          noRekeningErrorMessages,
          enTransfer,
        ]
      ];
}
