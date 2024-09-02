import 'package:equatable/equatable.dart';

import '../../domain/entities/update_address_entity.dart';

class UpdateAddressReq extends Equatable {
  final List<UpdateAddressEntity> data;

  const UpdateAddressReq(this.data);

  List<Map<dynamic, dynamic>> toJson() {
    return data
        .map((e) => {
              'district_id': e.districtId,
              'address': e.address,
              'type': e.type,
              'postal_code': e.postalCode
            })
        .toList();
  }

  @override
  List<Object?> get props => [data];
}
