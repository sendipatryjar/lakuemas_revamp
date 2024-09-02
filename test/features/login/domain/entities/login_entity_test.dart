import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/login/domain/entities/login_entity.dart';

void main() {
  test(
    'login entity',
    () {
      const result = LoginEntity(
        phoneNumber: '08123456789',
        email: 'jhon.doe@email.com',
      );

      expect(result, isNotNull);
      expect(result.phoneNumber, isA<String>());
      expect(result.phoneNumber, equals('08123456789'));
      expect(result.email, isA<String>());
      expect(result.email, equals('jhon.doe@email.com'));
    },
  );
}
