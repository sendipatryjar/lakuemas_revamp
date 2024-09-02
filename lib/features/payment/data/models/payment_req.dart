import 'package:equatable/equatable.dart';

import 'payment_debet_model.dart';

class PaymentReq extends Equatable {
  final int paymentMethodId;
  final String transactionKey;
  final String? jeniusCashtag;
  final String? phoneNumber;
  final String? couponCode;
  final PaymentDebetModel? paymentDebetModel;

  const PaymentReq({
    required this.paymentMethodId,
    required this.transactionKey,
    this.jeniusCashtag,
    this.phoneNumber,
    this.couponCode,
    this.paymentDebetModel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['payment_method_id'] = paymentMethodId;
    data['transaction_key'] = transactionKey;
    data['jenius_cashtag'] = jeniusCashtag;
    data['ovo_phone_number'] = phoneNumber;
    data['coupon_code'] = couponCode;
    data['credit_card'] = paymentDebetModel?.toJson();
    return data;
  }

  @override
  List<Object?> get props => [
        paymentMethodId,
        transactionKey,
        jeniusCashtag,
        phoneNumber,
        couponCode,
        paymentDebetModel,
      ];
}
