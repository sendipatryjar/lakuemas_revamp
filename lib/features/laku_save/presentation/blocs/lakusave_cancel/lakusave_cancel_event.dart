part of 'lakusave_cancel_bloc.dart';

abstract class LakusaveCancelEvent extends Equatable {
  const LakusaveCancelEvent();

  @override
  List<Object> get props => [];
}

class LakusaveCancelDoItEvent extends LakusaveCancelEvent {
  final String? transactionCode;

  const LakusaveCancelDoItEvent(this.transactionCode);

  @override
  List<Object> get props => [
        [transactionCode]
      ];
}

class LakusaveCancelInitEvent extends LakusaveCancelEvent {}
