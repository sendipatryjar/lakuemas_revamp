import 'package:equatable/equatable.dart';

class CheckoutConfirmEntity extends Equatable {
  final int? transactionId;
  final String? transactionCode;

  const CheckoutConfirmEntity({this.transactionId, this.transactionCode});

  @override
  List<Object?> get props => [transactionId, transactionCode];
}
