import 'package:equatable/equatable.dart';

class EliteRegisterEntity extends Equatable {
  final int? packageMonth;
  final double? grammationPrice;
  final String? transactionCode;
  final String? packageType;
  final String? subscriptionDateEnd;
  final String? paymentMethod;
  final String? autoRenewalPaymentMethod;
  final String? createdAt;

  const EliteRegisterEntity({
    this.packageMonth,
    this.grammationPrice,
    this.transactionCode,
    this.packageType,
    this.subscriptionDateEnd,
    this.paymentMethod,
    this.autoRenewalPaymentMethod,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        [
          packageMonth,
          grammationPrice,
          transactionCode,
          packageType,
          subscriptionDateEnd,
          paymentMethod,
          autoRenewalPaymentMethod,
          createdAt,
        ]
      ];
}
