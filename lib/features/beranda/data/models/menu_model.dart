import '../../domain/entities/menu_entity.dart';

class MenuModel extends MenuEntity {
  const MenuModel({
    int? id,
    String? name,
    String? description,
    int? parentId,
    int? position,
    int? isActive,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          name: name,
          description: description,
          parentId: parentId,
          position: position,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        parentId: json['parent_id'],
        position: json['position'],
        isActive: json['is_active'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'parent_id': parentId,
        'position': position,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
