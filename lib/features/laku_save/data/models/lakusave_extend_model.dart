import '../../domain/entities/lakusave_extend_entity.dart';

class LakusaveExtendModel extends LakusaveExtendEntity {
  const LakusaveExtendModel({int? id, String? name, String? description})
      : super(
          id: id,
          name: name,
          description: description,
        );

  factory LakusaveExtendModel.fromJson(Map<String, dynamic> json) =>
      LakusaveExtendModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
