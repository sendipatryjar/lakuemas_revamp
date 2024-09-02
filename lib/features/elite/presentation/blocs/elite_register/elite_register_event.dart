part of 'elite_register_bloc.dart';

abstract class EliteRegisterEvent extends Equatable {
  const EliteRegisterEvent();

  @override
  List<Object> get props => [];
}

class EliteRegisterEvents extends EliteRegisterEvent {
  final int? customerId;
  final int? packageId;
  final int? paymentMethodId;
  final String? voucherId;
  final String? autoRenewalPaymentMethod;
  final String? referalCode;

  const EliteRegisterEvents(
    this.customerId,
    this.packageId,
    this.paymentMethodId,
    this.voucherId,
    this.autoRenewalPaymentMethod,
    this.referalCode,
  );

  @override
  List<Object> get props => [
        [
          customerId,
          packageId,
          paymentMethodId,
          voucherId,
          autoRenewalPaymentMethod,
          referalCode,
        ]
      ];
}
