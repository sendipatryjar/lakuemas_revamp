part of 'get_voucher_referral_bloc.dart';

sealed class GetVoucherReferralEvent extends Equatable {
  const GetVoucherReferralEvent();

  @override
  List<Object> get props => [];
}

class GetVoucherReferralLoadEvent extends GetVoucherReferralEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetVoucherReferralLoadEvent({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}
