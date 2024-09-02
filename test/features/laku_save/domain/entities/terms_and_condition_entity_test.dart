import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/_core/others/domain/entities/terms_and_conditions_entity.dart';

void main() {
  test('terms and conditions entity', () {
    const result = TermsAndConditionsEntity(
      title: 'title',
      description: 'description',
    );

    expect(result, isNotNull);
    expect(result.title, equals('title'));
    expect(result.description, equals('description'));
  });
}
