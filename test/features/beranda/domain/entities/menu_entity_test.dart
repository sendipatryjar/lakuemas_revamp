import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/beranda/domain/entities/menu_entity.dart';

void main() {
  test(
    'menu entity',
    () {
      const result = MenuEntity(
        id: 1,
        name: 'name',
        description: 'description',
        parentId: 1,
        position: 1,
        isActive: 1,
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      );

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.name, equals('name'));
      expect(result.description, equals('description'));
      expect(result.parentId, equals(1));
      expect(result.position, equals(1));
      expect(result.isActive, equals(1));
      expect(result.createdAt, equals('createdAt'));
      expect(result.updatedAt, equals('updatedAt'));
    },
  );
}
