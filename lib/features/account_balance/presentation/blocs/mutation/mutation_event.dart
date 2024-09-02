part of 'mutation_bloc.dart';

abstract class MutationEvent extends Equatable {
  const MutationEvent();

  @override
  List<Object> get props => [];
}

class MutationGetEvent extends MutationEvent {
  final int? status;
  final String? period;
  final String? startDate;
  final String? endDate;

  const MutationGetEvent({
    this.status,
    this.period,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [
        [status, period, startDate, endDate]
      ];
}
