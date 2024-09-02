import 'package:equatable/equatable.dart';

class ProvinceEntity extends Equatable {
  final int? id;
  final String? name;

  const ProvinceEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
