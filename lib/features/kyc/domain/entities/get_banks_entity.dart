import 'package:equatable/equatable.dart';

class GetBanksEntity extends Equatable {
  final int? id;
  final String? bank;
  final String? bankMidtrans;
  final String? bankLogo;
  final int? sellingServiceFee;
  final String? bankBinBlock;

  const GetBanksEntity({
    this.id,
    this.bank,
    this.bankMidtrans,
    this.bankLogo,
    this.sellingServiceFee,
    this.bankBinBlock,
  });

  @override
  List<Object?> get props => [
        id,
        bank,
        bankMidtrans,
        bankLogo,
        sellingServiceFee,
        bankBinBlock,
      ];
}
