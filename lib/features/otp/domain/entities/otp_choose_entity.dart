import 'package:equatable/equatable.dart';

class OtpChooseEntity extends Equatable {
  final String? phoneNumber;
  final String? email;

  const OtpChooseEntity({
    this.phoneNumber,
    this.email,
  });

  @override
  List<Object?> get props => [
        [
          phoneNumber,
          email,
        ]
      ];
}
