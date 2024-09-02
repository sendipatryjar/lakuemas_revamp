import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_extend_entity.dart';

void main() {
  test('lakusave extend entity', () {
    const result = LakusaveExtendEntity(
      id: 1,
      name: 'tidak perpanjang',
      description: 'description',
    );

    expect(result, isNotNull);
    expect(result.id, equals(1));
    expect(result.name, equals('tidak perpanjang'));
    expect(result.description, equals('description'));
  });
}
