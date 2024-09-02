import '../../domain/entities/language_entity.dart';

class LanguageModel extends LanguageEntity {
  const LanguageModel({
    String? code,
    String? flag,
    String? name,
  }) : super(
          code: code,
          flag: flag,
          name: name,
        );

  LanguageModel.fromJson(Map<String, dynamic> json)
      : super(
          code: json['code'],
          flag: json['flag'],
          name: json['name'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = super.code;
    data['flag'] = super.flag;
    data['name'] = super.name;
    return data;
  }
}
