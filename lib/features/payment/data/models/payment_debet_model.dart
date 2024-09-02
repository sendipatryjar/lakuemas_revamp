import '../../domain/entities/payment_debet_entity.dart';

class PaymentDebetModel extends PaymentDebetEntity {
  const PaymentDebetModel({
    String? cardNumber,
    int? month,
    int? year,
    String? cvv,
  }) : super(
          cardNumber: cardNumber,
          month: month,
          year: year,
          cvv: cvv,
        );

  factory PaymentDebetModel.fromJson(Map<String, dynamic> json) =>
      PaymentDebetModel(
        cardNumber: json['card_number'],
        month: json['exp_month'],
        year: json['exp_year'],
        cvv: json['cvv'],
      );

  Map<String, dynamic> toJson() => {
        'card_number': cardNumber,
        'exp_month': month,
        'exp_year': year,
        'cvv': cvv,
      };
}
