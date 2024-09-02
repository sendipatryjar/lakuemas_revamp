part of 'get_voucher_referral_bloc.dart';

sealed class GetVoucherReferralState extends Equatable {
  const GetVoucherReferralState();

  @override
  List<Object> get props => [];
}

final class GetVoucherReferralInitial extends GetVoucherReferralState {}

final class GetVoucherReferralLoadingState extends GetVoucherReferralState {}

final class GetVoucherReferralSuccessState extends GetVoucherReferralState {
  final List<VoucherReferralEntity> voucherReferral;

  const GetVoucherReferralSuccessState(this.voucherReferral);

  @override
  List<Object> get props => [
        [voucherReferral],
      ];
}

final class GetVoucherReferralFailureState extends GetVoucherReferralState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetVoucherReferralFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
