import '../../domain/entities/bank_me_entity.dart';

class BankMeModel extends BankMeEntity {
  const BankMeModel({
    int? id,
    int? customerId,
    String? name,
    String? accountName,
    String? accountNumber,
    String? logo,
    String? serviceFee,
  }) : super(
          id: id,
          customerId: customerId,
          name: name,
          accountName: accountName,
          accountNumber: accountNumber,
          logo: logo,
          serviceFee: serviceFee,
        );

  factory BankMeModel.fromJson(Map<String, dynamic> json) => BankMeModel(
        id: json['id'],
        customerId: json['customer_id'],
        name: json['name'],
        accountName: json['account_name'],
        accountNumber: json['account_number'],
        logo: json['logo'],
        serviceFee: json['service_fee'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'name': name,
        'account_name': accountName,
        'account_number': accountNumber,
        'logo': logo,
        'service_fee': serviceFee,
      };
}
