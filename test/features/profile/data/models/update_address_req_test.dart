import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/data/models/update_address_req.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';

void main() {
  List<Map<String, dynamic>> reqData = [];

  group('update address req', () {
    setUp(() {
      reqData = [
        {
          'district_id': 1,
          'address': 'address1',
          'type': 'home',
          'postal_code': '12345',
        },
        {
          'district_id': 2,
          'address': 'address2',
          'type': 'mailing',
          'postal_code': '12349',
        }
      ];
    });
    test(
      'to json',
      () {
        final data = UpdateAddressReq([
          UpdateAddressEntity(
            address: 'address1',
            districtId: 1,
            postalCode: '12345',
            type: 'home',
          ),
          UpdateAddressEntity(
            address: 'address2',
            districtId: 2,
            postalCode: '12349',
            type: 'mailing',
          ),
        ]);
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
