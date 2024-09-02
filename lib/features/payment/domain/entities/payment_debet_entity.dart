import 'package:equatable/equatable.dart';

class PaymentDebetEntity extends Equatable {
  final int? month;
  final int? year;
  final String? cardNumber;
  final String? cvv;

  const PaymentDebetEntity({
    this.month,
    this.year,
    this.cardNumber,
    this.cvv,
  });

  PaymentDebetEntity copyWith({
    int? month,
    int? year,
    String? cardNumber,
    String? cvv,
  }) =>
      PaymentDebetEntity(
        month: month ?? this.month,
        year: year ?? this.year,
        cardNumber: cardNumber ?? this.cardNumber,
        cvv: cvv ?? this.cvv,
      );

  @override
  List<Object?> get props => [month, year, cardNumber, cvv];
}

class PaymentDebetEntityErr extends Equatable {
  final String? cardNumber;
  final String? expDate;
  final String? cvv;

  const PaymentDebetEntityErr({
    this.cardNumber,
    this.expDate,
    this.cvv,
  });

  PaymentDebetEntityErr copyWith({
    String? cardNumber,
    bool nullifyCardNumber = false,
    String? expDate,
    bool nullifyExpDate = false,
    String? cvv,
    bool nullifyCvv = false,
  }) =>
      PaymentDebetEntityErr(
        cardNumber: nullifyCardNumber ? null : (cardNumber ?? this.cardNumber),
        expDate: nullifyExpDate ? null : (expDate ?? this.expDate),
        cvv: nullifyCvv ? null : (cvv ?? this.cvv),
      );

  @override
  List<Object?> get props => [cardNumber, expDate, cvv];
}
