part of 'get_kyc_data_bloc.dart';

abstract class GetKycDataState extends Equatable {
  const GetKycDataState();
}

class GetKycDataInitial extends GetKycDataState {
  @override
  List<Object?> get props => [];
}

class GetKycDataLoadingState extends GetKycDataState {
  @override
  List<Object?> get props => [];
}

class GetKycDataSuccessState extends GetKycDataState {
  final Map<String, ObjectKycEntity?>? kycData;

  const GetKycDataSuccessState(this.kycData);

  @override
  List<Object> get props => [
        [kycData]
      ];
}

class GetKycDataFailureState extends GetKycDataState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetKycDataFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
