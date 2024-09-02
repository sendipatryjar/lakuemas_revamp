import '../../domain/entities/support_contact_entity.dart';

class SupportContactModel extends SupportContactEntity {
  const SupportContactModel({String? email, String? phoneNumber})
      : super(
          email: email,
          phoneNumber: phoneNumber,
        );

  factory SupportContactModel.fromJson(Map<String, dynamic> json) =>
      SupportContactModel(
        email: json['email'],
        phoneNumber: json['phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone_number': phoneNumber,
      };
}
