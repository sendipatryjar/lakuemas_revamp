import '../../../../physical_pull/data/models/detail_charge_model.dart';
import '../../domain/entities/checkout_entity.dart';

class CheckoutModel extends CheckoutEntity {
  const CheckoutModel({
    String? goldAmount,
    String? grossAmount,
    String? rounding,
    String? amount,
    String? nominalTax,
    String? percentageTax,
    String? goldPrice,
    String? transactionKey,
    List<DetailChargeModel>? detail,
  }) : super(
          goldAmount: goldAmount,
          grossAmount: grossAmount,
          rounding: rounding,
          amount: amount,
          nominalTax: nominalTax,
          percentageTax: percentageTax,
          goldPrice: goldPrice,
          transactionKey: transactionKey,
          detail: detail,
        );

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    List<DetailChargeModel>? detailEntity;
    if (json['detail'] != null) {
      detailEntity = <DetailChargeModel>[];
      json['detail'].forEach((v) {
        detailEntity!.add(DetailChargeModel.fromJson(v));
      });
    }

    return CheckoutModel(
      goldAmount: (json['gold_amount'] is int)
          ? (json['gold_amount'] as int).toDouble()
          : json['gold_amount'],
      grossAmount: json['gross_amount'],
      rounding: json['rounding'],
      amount: json['amount'],
      nominalTax: json['nominal_tax'],
      percentageTax: json['percentage_tax'],
      goldPrice: json['selling_price'] ?? json['purchase_price'],
      transactionKey: json['transaction_key'],
      detail: detailEntity,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gold_amount'] = goldAmount;
    data['gross_amount'] = grossAmount;
    data['rounding'] = rounding;
    data['amount'] = amount;
    data['nominal_tax'] = nominalTax;
    data['percentage_tax'] = percentageTax;
    data['purchase_price'] = goldPrice;
    data['transaction_key'] = transactionKey;
    if (detail != null) {
      data["detail"] = detail!.map((e) => DetailChargeModel(
            goldBrand: e.goldBrand,
            goldFragment: e.goldFragment,
            qty: e.qty,
            totalCertificateCost: e.totalCertificateCost,
          ));
    }
    return data;
  }
}
