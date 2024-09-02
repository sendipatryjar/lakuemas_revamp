import '../../domain/entities/faq_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    int? id,
    int? sequence,
    int? isactive,
    String? question,
    String? answer,
  }) : super(
          id: id,
          sequence: sequence,
          isactive: isactive,
          question: question,
          answer: answer,
        );

  static FaqModel fromJson(Map<String, dynamic> json) => FaqModel(
        id: json["id"],
        sequence: json["sequence"],
        isactive: json["isactive"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sequence": sequence,
        "isactive": isactive,
        "question": question,
        "answer": answer,
      };
}
