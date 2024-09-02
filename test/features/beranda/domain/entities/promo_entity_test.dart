import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/beranda/domain/entities/promo_entity.dart';

void main() {
  test(
    'promo entity',
    () {
      const result = PromoEntity(
        id: 1,
        title: 'title',
        content: 'content',
        imageUrl: 'imageUrl',
      );

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.title, equals('title'));
      expect(result.content, equals('content'));
      expect(result.imageUrl, equals('imageUrl'));
    },
  );
}
