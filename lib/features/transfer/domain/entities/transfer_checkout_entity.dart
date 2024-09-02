import 'package:equatable/equatable.dart';

class TransferCheckoutEntity extends Equatable {
  final String? transactionCode;

  const TransferCheckoutEntity({this.transactionCode});

  @override
  List<Object?> get props => [transactionCode];
}
