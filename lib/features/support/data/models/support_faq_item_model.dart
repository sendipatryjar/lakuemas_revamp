import '../../domain/entities/support_faq_entity.dart';

class SupportFaqItemModel extends SupportFaqItemEntity {
  const SupportFaqItemModel({
    String? question,
    String? answer,
  }) : super(
          question: question,
          answer: answer,
        );

  factory SupportFaqItemModel.fromJson(Map<String, dynamic> json) =>
      SupportFaqItemModel(
        question: json['question'],
        answer: json['answer'],
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };
}
