import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/account_balance/domain/entities/account_balance_faq_entity.dart';

void main() {
  test(
    'account balance faq entity',
    () {
      const result = AccountBalanceFaqEntity(
        question: 'question',
        answer: 'answer',
      );

      expect(result, isNotNull);
      expect(result.question, equals('question'));
      expect(result.answer, equals('answer'));
    },
  );
}
