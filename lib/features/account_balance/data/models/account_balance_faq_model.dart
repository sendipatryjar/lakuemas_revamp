import '../../domain/entities/account_balance_faq_entity.dart';

class AccountBalanceFaqModel extends AccountBalanceFaqEntity {
  const AccountBalanceFaqModel({
    String? question,
    String? answer,
  }) : super(
          question: question,
          answer: answer,
        );

  factory AccountBalanceFaqModel.fromJson(Map<String, dynamic> json) =>
      AccountBalanceFaqModel(
        question: json['question'],
        answer: json['answer'],
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };
}
