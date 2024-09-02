import '../../domain/entities/register_entity.dart';

class RegisterModelField {
  static const String id = 'id';
  static const String name = 'name';
  static const String phoneNumber = 'phone_number';
  static const String email = 'email';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  Map<String, Object?> toJson() => {
        RegisterModelField.id: id,
        RegisterModelField.name: name,
        RegisterModelField.phoneNumber: phoneNumber,
        RegisterModelField.email: email,
        RegisterModelField.createdAt: createdAt,
        RegisterModelField.updatedAt: updatedAt,
      };

  RegisterModel copy({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? createdAt,
    String? updatedAt,
  }) =>
      RegisterModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static RegisterModel fromJson(Map<String, Object?> json) => RegisterModel(
        id: json[RegisterModelField.id] as int?,
        name: json[RegisterModelField.name] as String?,
        phoneNumber: json[RegisterModelField.phoneNumber] as String?,
        email: json[RegisterModelField.email] as String?,
        createdAt: json[RegisterModelField.createdAt] as String?,
        updatedAt: json[RegisterModelField.updatedAt] as String?,
      );
}
