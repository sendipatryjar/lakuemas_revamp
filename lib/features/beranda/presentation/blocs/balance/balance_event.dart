part of 'balance_bloc.dart';

abstract class BerandaBalancesEvent extends Equatable {
  final dynamic data;
  const BerandaBalancesEvent(this.data);

  @override
  List<Object> get props => [data];
}

class BerandaBalancesGetEvent extends BerandaBalancesEvent {
  final HelperDataCubit helperDataCubit;

  BerandaBalancesGetEvent({
    required this.helperDataCubit,
  }) : super([
          helperDataCubit,
        ]);
}

class BerandaBalancesCopyValueEvent extends BerandaBalancesEvent {
  final BerandaBalancesBloc berandaBalanceBloc;

  BerandaBalancesCopyValueEvent({
    required this.berandaBalanceBloc,
  }) : super([
          berandaBalanceBloc,
        ]);
}
