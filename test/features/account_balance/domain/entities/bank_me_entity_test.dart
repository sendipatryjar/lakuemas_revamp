import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/account_balance/domain/entities/bank_me_entity.dart';

void main() {
  test(
    'bank me entity',
    () {
      const result = BankMeEntity(
        id: 1,
        customerId: 1,
        name: 'name',
        accountName: 'accountName',
        accountNumber: '123456789',
        logo: 'logo',
        serviceFee: '500',
      );

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.customerId, equals(1));
      expect(result.name, equals('name'));
      expect(result.accountName, equals('accountName'));
      expect(result.accountNumber, equals('123456789'));
      expect(result.logo, equals('logo'));
      expect(result.serviceFee, equals('500'));
    },
  );
}
