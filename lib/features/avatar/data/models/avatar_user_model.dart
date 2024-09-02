import '../../domain/entities/avatar_user_entity.dart';

class AvatarUserModel extends AvatarUserEntity {
  const AvatarUserModel({
    List<String>? partners,
    List<String>? applicationIds,
    String? createdAt,
    String? updatedAt,
    String? id,
  }) : super(
          partners: partners,
          applicationIds: applicationIds,
          createdAt: createdAt,
          updatedAt: updatedAt,
          id: id,
        );

  factory AvatarUserModel.fromJson(Map<String, dynamic> json) {
    List<String>? partnersHelper;
    if (json['partners'] != null) {
      partnersHelper = <String>[];
      json['partners'].forEach((v) {
        partnersHelper!.add((v as String));
      });
    }

    List<String>? applicationIdsHelper;
    if (json['applicationIds'] != null) {
      applicationIdsHelper = <String>[];
      json['applicationIds'].forEach((v) {
        applicationIdsHelper!.add((v as String));
      });
    }

    return AvatarUserModel(
      partners: partnersHelper,
      applicationIds: applicationIdsHelper,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'partners': partners,
        'applicationIds': applicationIds,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'id': id,
      };
}
