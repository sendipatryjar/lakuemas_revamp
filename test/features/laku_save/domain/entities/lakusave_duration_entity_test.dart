import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_duration_entity.dart';

void main() {
  test(
    'lakusave duration entity',
    () {
      const result = LakusaveDurationEntity(
        id: 1,
        duration: 4,
        type: 'type',
      );

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.duration, equals(4));
      expect(result.type, equals('type'));
    },
  );
}
