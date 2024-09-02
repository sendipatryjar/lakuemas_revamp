import 'package:equatable/equatable.dart';

class AvatarUserEntity extends Equatable {
  final List<String>? partners;
  final List<String>? applicationIds;
  final String? createdAt;
  final String? updatedAt;
  final String? id;

  const AvatarUserEntity({
    this.partners,
    this.applicationIds,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  @override
  List<Object?> get props =>
      [partners, applicationIds, createdAt, updatedAt, id];
}
