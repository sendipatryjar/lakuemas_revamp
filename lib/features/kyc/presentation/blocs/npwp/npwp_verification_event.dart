part of 'npwp_verification_bloc.dart';

abstract class NpwpVerificationEvent extends Equatable {
  const NpwpVerificationEvent();

  @override
  List<Object> get props => [];
}

class NpwpVerificationPressedEvent extends NpwpVerificationEvent {
  final String npwpNo;
  final String npwpPhotoBytes;

  const NpwpVerificationPressedEvent(this.npwpNo, this.npwpPhotoBytes);

  @override
  List<Object> get props => [npwpNo, npwpPhotoBytes];
}
