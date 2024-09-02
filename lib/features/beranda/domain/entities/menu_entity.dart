import 'package:equatable/equatable.dart';

class MenuEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final int? parentId;
  final int? position;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  const MenuEntity({
    this.id,
    this.name,
    this.description,
    this.parentId,
    this.position,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        parentId,
        position,
        isActive,
        createdAt,
        updatedAt,
      ];
}
