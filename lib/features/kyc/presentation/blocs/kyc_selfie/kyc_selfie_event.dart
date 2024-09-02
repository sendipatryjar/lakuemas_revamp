part of 'kyc_selfie_bloc.dart';

abstract class KycSelfieEvent extends Equatable {
  const KycSelfieEvent();

  @override
  List<Object> get props => [];
}

class KycSelfiePressed extends KycSelfieEvent {
  final List<int>? selfiePhotoBytes;

  const KycSelfiePressed({this.selfiePhotoBytes});

  @override
  List<Object> get props => [
        [selfiePhotoBytes]
      ];
}
