part of 'get_banks_bloc.dart';

abstract class GetBanksState extends Equatable {
  const GetBanksState();

  @override
  List<Object> get props => [];
}

class GetBanksInitial extends GetBanksState {}

class GetBanksLoadingState extends GetBanksState {}

class GetBanksSuccessState extends GetBanksState {
  final List<GetBanksEntity> data;

  const GetBanksSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class GetBanksFailureState extends GetBanksState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetBanksFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
