part of 'elite_unsub_validation_cubit.dart';

class EliteUnsubValidationState extends Equatable {
  final bool? isReasonUnsubError;
  final String? reasonUnsubMessagesCb;
  final String? reasonUnsubMessages;
  const EliteUnsubValidationState({
    this.isReasonUnsubError,
    this.reasonUnsubMessagesCb,
    this.reasonUnsubMessages,
  });

  EliteUnsubValidationState copyWith({
    bool? isReasonUnsubError,
    String? reasonUnsubMessagesCb,
    bool nullifyReasonUnsubMessageCb = false,
    String? reasonUnsubMessages,
    bool nullifyReasonUnsubMessage = false,
  }) =>
      EliteUnsubValidationState(
        isReasonUnsubError: isReasonUnsubError ?? this.isReasonUnsubError,
        reasonUnsubMessagesCb: nullifyReasonUnsubMessageCb
            ? null
            : (reasonUnsubMessagesCb ?? this.reasonUnsubMessagesCb),
        reasonUnsubMessages: nullifyReasonUnsubMessage
            ? null
            : (reasonUnsubMessages ?? this.reasonUnsubMessages),
      );

  @override
  List<Object> get props => [
        [isReasonUnsubError, reasonUnsubMessagesCb, reasonUnsubMessages]
      ];
}
