part of 'master_data_lakusave_bloc.dart';

abstract class MasterDataLakusaveEvent extends Equatable {
  const MasterDataLakusaveEvent();

  @override
  List<Object> get props => [];
}

class MasterDataLakusaveGetEvent extends MasterDataLakusaveEvent {}
