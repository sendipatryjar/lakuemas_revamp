import '../../domain/entities/detail_transaction_entity.dart';
import 'certificates_model.dart';
import 'deposit_model.dart';
import 'detail_payment_method_model.dart';
import 'detail_transaction_item_model.dart';
import 'elite_subs_model.dart';
import 'shipment_model.dart';

class DetailTransactionModel extends DetailTransactionEntity {
  const DetailTransactionModel({
    bool? isTransfered,
    int? id,
    int? status,
    double? expirationTime,
    String? amount,
    String? grossAmount,
    String? discount,
    String? rounding,
    String? sellingPrice,
    String? purchasePrice,
    String? nominalTax,
    String? goldAmount,
    String? percentageTax,
    String? serviceFee,
    String? code,
    String? type,
    String? statusLabel,
    String? accountName,
    String? accountNumber,
    String? news,
    String? createdAt,
    DetailPaymentMethodModel? payment,
    List<CertificatesModel>? certificates,
    ShipmentModel? shipment,
    //
    String? bankName,
    String? bankLogo,
    //
    int? packageMonth,
    String? validUntil,
    int? nominal,
    String? total,
    String? paymentMethod,
    String? autoRenewalPaymentMethod,
    String? statusName,
    String? paymentExpiredAt,
    DetailTransactionItemModel? item,
    //
    EliteSubsModel? elite,
    //
    DepositModel? deposit,
  }) : super(
          isTransfered: isTransfered,
          id: id,
          status: status,
          expirationTime: expirationTime,
          amount: amount,
          grossAmount: grossAmount,
          discount: discount,
          rounding: rounding,
          sellingPrice: sellingPrice,
          purchasePrice: purchasePrice,
          nominalTax: nominalTax,
          goldAmount: goldAmount,
          percentageTax: percentageTax,
          serviceFee: serviceFee,
          code: code,
          type: type,
          statusLabel: statusLabel,
          accountName: accountName,
          accountNumber: accountNumber,
          news: news,
          createdAt: createdAt,
          payment: payment,
          certificates: certificates,
          shipment: shipment,
          bankName: bankName,
          bankLogo: bankLogo,
          //
          packageMonth: packageMonth,
          validUntil: validUntil,
          nominal: nominal,
          total: total,
          paymentMethod: paymentMethod,
          autoRenewalPaymentMethod: autoRenewalPaymentMethod,
          statusName: statusName,
          paymentExpiredAt: paymentExpiredAt,
          item: item,
          elite: elite,
          //
          deposit: deposit,
        );

  factory DetailTransactionModel.fromJson(Map<String, dynamic> json) =>
      DetailTransactionModel(
        isTransfered: json['is_transferred'],
        id: json['id'] ?? json['transaction_id'],
        status: json['status'],
        expirationTime: (json['expiration_time'] is int)
            ? (json['expiration_time'] as int).toDouble()
            : json['expiration_time'],
        amount: json['amount'],
        grossAmount: json['gross_amount'],
        discount: json['discount'],
        rounding: json['rounding'],
        sellingPrice: json['selling_price'],
        purchasePrice: json['purchase_price'],
        nominalTax: json['nominal_tax'],
        goldAmount: json['gold_amount'],
        percentageTax: json['percentage_tax'],
        serviceFee: json['service_fee'] is int
            ? json['service_fee'].toString()
            : json['service_fee'],
        code: json['code'] ?? json['transaction_code'],
        type: json['type'],
        statusLabel: json['status_label'],
        accountName: json['account_name'],
        accountNumber: json['account_number'],
        news: json['news'],
        createdAt: json['created_at'],
        payment: json['payment'] != null
            ? DetailPaymentMethodModel.fromJson(json['payment'])
            : null,
        certificates: json["certificates"] == null
            ? []
            : List<CertificatesModel>.from(json["certificates"]!
                .map((x) => CertificatesModel.fromJson(x))),
        shipment: json['shipment'] != null
            ? ShipmentModel.fromJson(json['shipment'])
            : null,
        //
        bankName: json['bank_name'],
        bankLogo: json['bank_logo'],
        //
        packageMonth: json["package_month"],
        validUntil: json["valid_until"],
        nominal: json["nominal"],
        total: json["total"],
        paymentMethod: json["payment_method"],
        autoRenewalPaymentMethod: json["auto_renewal_payment_method"],
        statusName: json["status_name"],
        paymentExpiredAt: json["payment_expired_at"],
        item: json['item'] != null
            ? DetailTransactionItemModel.fromJson(json['item'])
            : null,
        //
        elite: json['elite'] != null
            ? EliteSubsModel.fromJson(json['elite'])
            : null,
        //
        deposit: json["deposit"] == null
            ? null
            : DepositModel.fromJson(json["deposit"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_transferred'] = isTransfered;
    data['id'] = id;
    data['status'] = id;
    data['expiration_time'] = id;
    data['amount'] = id;
    data['gross_amount'] = id;
    data['discount'] = id;
    data['rounding'] = rounding;
    data['selling_price'] = id;
    data['purchase_price'] = id;
    data['nominal_tax'] = id;
    data['gold_amount'] = id;
    data['percentage_tax'] = id;
    data['service_fee'] = id;
    data['code'] = id;
    data['type'] = id;
    data['status_label'] = id;
    data['created_at'] = id;
    data['news'] = news;
    data['payment'] = DetailPaymentMethodModel(
      name: payment?.name,
      imageUrl: payment?.imageUrl,
      vaNo: payment?.vaNo,
      billerCode: payment?.billerCode,
      paymentCode: payment?.paymentCode,
      instruction: payment?.instruction,
      actions: payment?.actions ?? const [],
    ).toJson();
    if (certificates != null) {
      data["certificates"] = certificates!.map((e) => CertificatesModel(
            goldFragment: e.goldFragment,
            goldBrand: e.goldBrand,
            certificateCost: e.certificateCost,
          ));
    }
    data['shipment'] = ShipmentModel(
      type: shipment?.type,
      storeName: shipment?.storeName,
      address: shipment?.address,
      expidition: shipment?.expidition,
      receiptNumber: shipment?.receiptNumber,
    ).toJson();
    //
    data['bank_name'] = bankName;
    data['bank_logo'] = bankLogo;
    //
    data["package_month"] = packageMonth;
    data["valid_until"] = validUntil;
    data["nominal"] = nominal;
    data["total"] = total;
    data["payment_method"] = paymentMethod;
    data["auto_renewal_payment_method"] = autoRenewalPaymentMethod;
    data["status_name"] = statusName;
    data["payment_expired_at"] = paymentExpiredAt;

    data['item'] = DetailTransactionItemModel(
      weight: item?.weight,
      brand: item?.brand,
      storeName: item?.storeName,
      storeAddress: item?.storeAddress,
    ).toJson();

    data['elite'] = EliteSubsModel(
      packageMonth: elite?.packageMonth,
      grammationPrice: elite?.grammationPrice,
      packageType: elite?.packageType,
      subscriptionDateEnd: elite?.subscriptionDateEnd,
      paymentMethod: elite?.paymentMethod,
      autoRenewalPaymentMethod: elite?.autoRenewalPaymentMethod,
    ).toJson();
    //
    data['deposit'] = DepositModel(
      isEnableUpdateExtend: deposit?.isEnableUpdateExtend,
      accountNumber: deposit?.accountNumber,
      interest: deposit?.interest,
      duration: deposit?.duration,
      durationType: deposit?.durationType,
      extendLabel: deposit?.extendLabel,
      startDate: deposit?.startDate,
      endDate: deposit?.endDate,
    ).toJson();
    return data;
  }
}
