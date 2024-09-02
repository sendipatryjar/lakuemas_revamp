import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  const RegisterEntity({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        createdAt,
        updatedAt,
      ];
}
