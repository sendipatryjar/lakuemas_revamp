import '../../domain/entities/get_banks_entity.dart';

// ignore: must_be_immutable
class BankAccountModel extends GetBanksEntity {
  const BankAccountModel({
    int? id,
    String? bank,
    String? bankMidtrans,
    String? bankLogo,
    int? sellingServiceFee,
    String? bankBinBlock,
  }) : super(
          id: id,
          bank: bank,
          bankMidtrans: bankMidtrans,
          bankLogo: bankLogo,
          sellingServiceFee: sellingServiceFee,
          bankBinBlock: bankBinBlock,
        );

  static BankAccountModel fromJson(Map<String, dynamic> json) =>
      BankAccountModel(
        id: json['id'],
        bank: json['bank'],
        bankMidtrans: json['bank_midtrans'],
        bankLogo: json['bank_logo'],
        sellingServiceFee: json['selling_service_fee'],
        bankBinBlock: json['bank_bin_block'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'bank': bank,
        'bank_midtrans': bankMidtrans,
        'bank_logo': bankLogo,
        'selling_service_fee': sellingServiceFee,
        'bank_bin_block': bankBinBlock,
      };
}
