import '../../domain/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  const PromoModel({
    int? id,
    String? title,
    String? content,
    String? image,
  }) : super(
          id: id,
          title: title,
          content: content,
          imageUrl: image,
        );

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'image': imageUrl,
      };
}
