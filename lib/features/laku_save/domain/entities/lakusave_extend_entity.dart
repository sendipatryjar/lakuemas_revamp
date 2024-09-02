import 'package:equatable/equatable.dart';

class LakusaveExtendEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  const LakusaveExtendEntity({this.id, this.name, this.description});

  @override
  List<Object?> get props => [id, name, description];
}
