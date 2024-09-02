import 'package:equatable/equatable.dart';

class DistrictEntity extends Equatable {
  final int? id;
  final String? name;
  final int? cityId;

  const DistrictEntity({this.id, this.name, this.cityId});

  @override
  List<Object?> get props => [id, name, cityId];
}
