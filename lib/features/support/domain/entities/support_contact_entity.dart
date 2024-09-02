import 'package:equatable/equatable.dart';

class SupportContactEntity extends Equatable {
  final String? email;
  final String? phoneNumber;

  const SupportContactEntity({this.email, this.phoneNumber});

  @override
  List<Object?> get props => [email, phoneNumber];
}
