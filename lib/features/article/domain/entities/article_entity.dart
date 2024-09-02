import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final int? id;
  final String? title;
  final String? pageTitle;
  final String? permalink;
  final String? smText;
  final String? midText;
  final String? content;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;

  const ArticleEntity({
    this.id,
    this.title,
    this.pageTitle,
    this.permalink,
    this.smText,
    this.midText,
    this.content,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        pageTitle,
        permalink,
        smText,
        midText,
        content,
        image,
        createdAt,
        updatedAt,
        isActive,
      ];
}
