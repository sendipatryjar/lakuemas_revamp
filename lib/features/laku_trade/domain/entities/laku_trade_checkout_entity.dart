import 'package:equatable/equatable.dart';

class LakuTradeCheckoutEntity extends Equatable {
  final String? tid;
  final String? transactionCode;
  final String? traceNo;

  const LakuTradeCheckoutEntity({this.tid, this.transactionCode, this.traceNo});

  @override
  List<Object?> get props => [tid, transactionCode, traceNo];
}
