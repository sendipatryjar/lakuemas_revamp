import '../../domain/entities/social_media_config_entity.dart';

class SocialMediaConfigModel extends SocialMediaConfigEntity {
  const SocialMediaConfigModel({
    String? text,
    String? image,
  }) : super(
          text: text,
          image: image,
        );

  static SocialMediaConfigModel fromJson(Map<String, dynamic> json) =>
      SocialMediaConfigModel(
        text: json["text"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "image": image,
      };
}
