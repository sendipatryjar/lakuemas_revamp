part of 'get_kyc_data_bloc.dart';

abstract class GetKycDataEvent extends Equatable {
  const GetKycDataEvent();

  @override
  List<Object> get props => [];
}

class GetKycTriggered extends GetKycDataEvent {}
