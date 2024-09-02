import 'package:equatable/equatable.dart';

class EliteSubsEntity extends Equatable {
  final String? packageMonth;
  final String? grammationPrice;
  final String? packageType;
  final String? subscriptionDateEnd;
  final String? paymentMethod;
  final String? autoRenewalPaymentMethod;

  const EliteSubsEntity({
    this.packageMonth,
    this.grammationPrice,
    this.packageType,
    this.subscriptionDateEnd,
    this.paymentMethod,
    this.autoRenewalPaymentMethod,
  });

  @override
  List<Object?> get props => [
        [
          packageMonth,
          grammationPrice,
          packageType,
          subscriptionDateEnd,
          paymentMethod,
          autoRenewalPaymentMethod,
        ]
      ];
}
