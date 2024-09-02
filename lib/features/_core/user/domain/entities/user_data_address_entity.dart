import 'package:equatable/equatable.dart';

class UserDataAddressEntity extends Equatable {
  final String? address;
  final String? type;
  final int? districtId;
  final String? postalCode;

  const UserDataAddressEntity(
      {this.address, this.type, this.districtId, this.postalCode});

  @override
  List<Object> get props => [
        [
          address,
          type,
          districtId,
          postalCode,
        ]
      ];
}
