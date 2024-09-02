import '../../domain/entities/lakusave_duration_entity.dart';

class LakusaveDurationModel extends LakusaveDurationEntity {
  const LakusaveDurationModel({
    int? id,
    String? type,
    int? duration,
  }) : super(
          id: id,
          type: type,
          duration: duration,
        );

  factory LakusaveDurationModel.fromJson(Map<String, dynamic> json) =>
      LakusaveDurationModel(
        id: json['id'],
        type: json['type'],
        duration: json['duration'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'duration': duration,
      };
}
