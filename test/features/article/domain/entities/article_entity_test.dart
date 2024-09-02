import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/article/domain/entities/article_entity.dart';

void main() {
  test(
    'article entity',
    () {
      const result = ArticleEntity(
        id: 1,
        content: 'content',
        image: 'image',
        pageTitle: 'pageTitle',
        midText: 'midText',
        smText: 'smText',
        title: 'title',
        permalink: 'permalink',
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
      );

      expect(result, isNotNull);
      expect(result.id, equals(1));
      expect(result.content, equals('content'));
      expect(result.image, equals('image'));
      expect(result.pageTitle, equals('pageTitle'));
      expect(result.midText, equals('midText'));
      expect(result.smText, equals('smText'));
      expect(result.title, equals('title'));
      expect(result.permalink, equals('permalink'));
      expect(result.createdAt, equals('createdAt'));
      expect(result.updatedAt, equals('updatedAt'));
    },
  );
}
