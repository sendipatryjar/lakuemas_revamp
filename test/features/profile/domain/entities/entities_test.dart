import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/domain/entities/city_entity.dart';
import 'package:lakuemas/features/profile/domain/entities/district_entity.dart';
import 'package:lakuemas/features/profile/domain/entities/province_entity.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';

void main() {
  test(
    'city entity',
    () {
      const result = CityEntity(id: 1, city: 'qwerty', provinceId: 1);

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.city, equals('qwerty'));
      expect(result.provinceId, equals(1));
    },
  );

  test(
    'district entity',
    () {
      const result = DistrictEntity(id: 1, name: 'qwerty', cityId: 1);

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.name, equals('qwerty'));
      expect(result.cityId, equals(1));
    },
  );

  test(
    'province entity',
    () {
      const result = ProvinceEntity(id: 1, name: 'qwerty');

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.name, equals('qwerty'));
    },
  );

  test(
    'update address entity',
    () {
      var result = UpdateAddressEntity(
        address: 'address1',
        districtId: 1,
        postalCode: '12345',
        type: 'type01',
      );

      expect(result, isNotNull);
      expect(result.address, equals('address1'));
      expect(result.districtId, equals(1));
      expect(result.postalCode, equals('12345'));
      expect(result.type, equals('type01'));
    },
  );
}
