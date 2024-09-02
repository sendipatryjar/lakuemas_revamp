import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int? transactionId;
  final String? transactionCode;

  const PaymentEntity({this.transactionId, this.transactionCode});

  @override
  List<Object?> get props => [transactionId, transactionCode];
}
