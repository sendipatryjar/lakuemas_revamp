import 'package:equatable/equatable.dart';

class LakuTradeStoreEntity extends Equatable {
  final String? name;
  final String? address;

  const LakuTradeStoreEntity({this.name, this.address});

  @override
  List<Object?> get props => [name, address];
}
