import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/register/domain/entities/register_entity.dart';

void main() {
  test(
    'register entity',
    () {
      const result = RegisterEntity(
        id: 1,
        name: 'jhon doe',
        phoneNumber: '08123456789',
        email: 'jhon.doe@email.com',
        createdAt: '2019-08-24T14:15:22Z',
        updatedAt: '2019-08-24T14:15:22Z',
      );

      expect(result, isNotNull);
      expect(result.id, isA<int>());
      expect(result.name, isA<String>());
      expect(result.phoneNumber, isA<String>());
      expect(result.email, isA<String>());
      expect(result.createdAt, isA<String>());
      expect(result.updatedAt, isA<String>());
    },
  );
}
