import 'package:equatable/equatable.dart';

class DetailPaymentMethodEntity extends Equatable {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? vaNo;
  final String? billerCode;
  final String? paymentCode;
  final String? instruction;
  final List<DetailPaymentMethodActionEntity> actions;

  const DetailPaymentMethodEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.vaNo,
    this.billerCode,
    this.paymentCode,
    this.instruction,
    this.actions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        vaNo,
        billerCode,
        paymentCode,
        instruction,
        actions,
      ];
}

class DetailPaymentMethodActionEntity extends Equatable {
  final String? name;
  final String? method;
  final String? url;

  const DetailPaymentMethodActionEntity({
    this.name,
    this.method,
    this.url,
  });

  @override
  List<Object?> get props => [name, method, url];
}
