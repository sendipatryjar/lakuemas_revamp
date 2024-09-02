class EliteRegisterReq {
  final int? customerId;
  final int? packageId;
  final int? paymentMethodId;
  final String? voucherId;
  final String? autoRenewalPaymentMethod;
  final String? referalCode;

  EliteRegisterReq({
    this.customerId,
    this.packageId,
    this.paymentMethodId,
    this.voucherId,
    this.autoRenewalPaymentMethod = 'SALDO_EMAS',
    this.referalCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'package_id': packageId,
      'payment_method_id': paymentMethodId,
      'voucher_code': voucherId,
      'auto_renewal_payment_method': autoRenewalPaymentMethod,
      'referral_code': referalCode,
    };
  }

  EliteRegisterReq copyWith({
    int? customerId,
    int? packageId,
    int? paymentMethodId,
    String? voucherId,
    String? referalCode,
  }) =>
      EliteRegisterReq(
        customerId: customerId ?? this.customerId,
        packageId: packageId ?? this.packageId,
        paymentMethodId: paymentMethodId ?? this.paymentMethodId,
        voucherId: voucherId ?? this.voucherId,
        autoRenewalPaymentMethod: autoRenewalPaymentMethod,
        referalCode: referalCode ?? this.referalCode,
      );
}
