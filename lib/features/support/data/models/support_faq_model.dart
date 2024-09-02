import '../../domain/entities/support_faq_entity.dart';
import 'support_faq_item_model.dart';

class SupportFaqModel extends SupportFaqEntity {
  const SupportFaqModel({
    String? title,
    List<SupportFaqItemEntity>? items,
  }) : super(
          title: title,
          items: items,
        );

  factory SupportFaqModel.fromJson(Map<String, dynamic> json) {
    List<SupportFaqItemModel>? supportFaqItems;
    if (json['items'] != null) {
      supportFaqItems = <SupportFaqItemModel>[];
      json['items'].forEach((v) {
        supportFaqItems!.add(SupportFaqItemModel.fromJson(v));
      });
    }

    return SupportFaqModel(
      title: json['title'],
      items: supportFaqItems,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'items': items?.map((v) => SupportFaqItemModel(
                      question: v.question,
                      answer: v.answer,
                    ).toJson())
                .toList(),
      };
}
