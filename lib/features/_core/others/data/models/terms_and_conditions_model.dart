import '../../domain/entities/terms_and_conditions_entity.dart';

class TermsAndConditionsModel extends TermsAndConditionsEntity {
  const TermsAndConditionsModel({String? title, String? description})
      : super(
          title: title,
          description: description,
        );

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionsModel(
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
