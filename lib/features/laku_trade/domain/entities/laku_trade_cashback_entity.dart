import 'package:equatable/equatable.dart';

class LakuTradeCashbackEntity extends Equatable {
  final String? nominal;
  final String? rate;
  final String? remark;

  const LakuTradeCashbackEntity({
    this.nominal,
    this.rate,
    this.remark,
  });

  @override
  List<Object?> get props => [nominal, rate, remark];
}
