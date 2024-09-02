part of 'kyc_ktp_bloc.dart';

abstract class KycKtpEvent extends Equatable {
  const KycKtpEvent();

  @override
  List<Object> get props => [];
}

class KycKtpPressed extends KycKtpEvent {
  final AppLocalizations t;
  final String? nik;
  final String? name;
  final String? pob;
  final String? dob;
  final List<int>? ktpPhoto;

  const KycKtpPressed({
    required this.t,
    this.nik,
    this.name,
    this.pob,
    this.dob,
    this.ktpPhoto,
  });
}
