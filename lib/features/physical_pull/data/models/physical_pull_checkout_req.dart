class PhysicalPullCheckoutReq {
  final int? paymentMethodId;
  final int? storeId;
  final int? courierPriceId;
  final String? deliveryMethod;
  final String? destinationAddress;
  final String? transactionKey;
  final String? jeniusCashtag;
  final String? ovoPhoneNumber;

  const PhysicalPullCheckoutReq({
    this.paymentMethodId,
    this.storeId,
    this.courierPriceId,
    this.deliveryMethod,
    this.destinationAddress,
    this.transactionKey,
    this.jeniusCashtag,
    this.ovoPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "payment_method_id": paymentMethodId,
      "store_id": storeId,
      "courier_price_id": courierPriceId,
      "delivery_method": deliveryMethod, // courier, store_pickup
      "destination_address": destinationAddress,
      "transaction_key": transactionKey,
      "jenius_cashtag": jeniusCashtag,
      "ovo_phone_number": ovoPhoneNumber,
    };
  }

  PhysicalPullCheckoutReq copyWith({
    int? paymentMethodId,
    int? storeId,
    int? courierPriceId,
    String? deliveryMethod,
    String? destinationAddress,
    String? transactionKey,
    String? jeniusCashtag,
    String? ovoPhoneNumber,
  }) =>
      PhysicalPullCheckoutReq(
        paymentMethodId: paymentMethodId ?? this.paymentMethodId,
        storeId: storeId ?? this.storeId,
        courierPriceId: courierPriceId ?? this.courierPriceId,
        deliveryMethod: deliveryMethod ?? this.deliveryMethod,
        destinationAddress: destinationAddress ?? this.destinationAddress,
        transactionKey: transactionKey ?? this.transactionKey,
        jeniusCashtag: jeniusCashtag ?? this.jeniusCashtag,
        ovoPhoneNumber: ovoPhoneNumber ?? this.ovoPhoneNumber,
      );
}
