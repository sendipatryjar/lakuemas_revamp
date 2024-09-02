part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentDoNowEvent extends PaymentEvent {
  final int paymentMethodId;
  final String transactionKey;
  final String? jeniusCashtag;
  final String? phoneNumber;
  final String? couponCode;
  final PaymentDebetEntity? paymentDebetEntity;

  const PaymentDoNowEvent({
    required this.paymentMethodId,
    required this.transactionKey,
    this.jeniusCashtag,
    this.phoneNumber,
    this.couponCode,
    this.paymentDebetEntity,
  });

  @override
  List<Object> get props => [
        paymentMethodId,
        transactionKey,
        [jeniusCashtag, phoneNumber, couponCode, paymentDebetEntity],
      ];
}
