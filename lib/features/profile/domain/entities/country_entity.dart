import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;

  const CountryEntity({
    this.id,
    this.code,
    this.name,
  });

  @override
  List<Object?> get props => [id, code, name];
}
