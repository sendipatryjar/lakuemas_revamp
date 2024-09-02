import '../../domain/entities/user_data_address_entity.dart';

class UserDataAddressModel extends UserDataAddressEntity {
  const UserDataAddressModel({
    String? address,
    String? type,
    int? districtId,
    String? postalCode,
  }) : super(
          address: address,
          type: type,
          districtId: districtId,
          postalCode: postalCode,
        );

  static UserDataAddressModel fromJson(Map<String, dynamic> json) {
    return UserDataAddressModel(
      address: json['address'],
      type: json['type'],
      districtId: json['district_id'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['type'] = type;
    data['district_id'] = districtId;
    data['postal_code'] = postalCode;
    return data;
  }
}
