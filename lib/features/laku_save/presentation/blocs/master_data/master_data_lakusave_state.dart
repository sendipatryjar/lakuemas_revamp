part of 'master_data_lakusave_bloc.dart';

abstract class MasterDataLakusaveState extends Equatable {
  const MasterDataLakusaveState();

  @override
  List<Object> get props => [];
}

class MasterDataLakusaveInitialState extends MasterDataLakusaveState {}

class MasterDataLakusaveLoadingState extends MasterDataLakusaveState {}

class MasterDataLakusaveSuccessState extends MasterDataLakusaveState {
  final GoldDepositEntity? goldDepositEntity;

  const MasterDataLakusaveSuccessState({
    this.goldDepositEntity,
  });

  @override
  List<Object> get props => [
        [goldDepositEntity]
      ];
}

class MasterDataLakusaveFailureState extends MasterDataLakusaveState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const MasterDataLakusaveFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
