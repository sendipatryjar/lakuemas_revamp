part of 'lakusave_bloc.dart';

abstract class LakusaveEvent extends Equatable {
  const LakusaveEvent();

  @override
  List<Object> get props => [];
}

class LakusaveGetTransactionsEvent extends LakusaveEvent {
  final int? status;

  const LakusaveGetTransactionsEvent({this.status});

  @override
  List<Object> get props => [
        [status]
      ];
}
