import '../../domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    int? id,
    String? title,
    String? pageTitle,
    String? permalink,
    String? smText,
    String? midText,
    String? content,
    String? image,
    String? createdAt,
    String? updatedAt,
    int? isActive,
  }) : super(
          id: id,
          title: title,
          pageTitle: pageTitle,
          permalink: permalink,
          smText: smText,
          midText: midText,
          content: content,
          image: image,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isActive: isActive == 1 ? true : false,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        id: json['id'],
        title: json['title'],
        pageTitle: json['page_title'],
        permalink: json['permalink'],
        smText: json['sm_text'],
        midText: json['mid_text'],
        content: json['content'],
        image: json['image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'page_title': pageTitle,
        'permalink': permalink,
        'sm_text': smText,
        'mid_text': midText,
        'content': content,
        'image': image,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_active': isActive
      };
}
