part of 'close_account_validation_cubit.dart';

class CloseAccountValidationState extends Equatable {
  final bool? isClsAccError;
  final String? isClsAccErrorMessage;

  const CloseAccountValidationState({
    this.isClsAccError,
    this.isClsAccErrorMessage,
  });

  CloseAccountValidationState copyWith({
    bool? isClsAccError,
    String? isClsAccErrorMessage,
  }) =>
      CloseAccountValidationState(
        isClsAccError: isClsAccError ?? this.isClsAccError,
        isClsAccErrorMessage: isClsAccErrorMessage ?? this.isClsAccErrorMessage,
      );

  @override
  List<Object?> get props => [
        isClsAccError,
        isClsAccErrorMessage,
      ];
}
