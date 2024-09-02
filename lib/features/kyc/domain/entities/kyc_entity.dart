import 'package:equatable/equatable.dart';

import 'object_kyc_entity.dart';

// ignore: must_be_immutable
class KycEntity extends Equatable {
  // int? id;
  // String? name;
  Map<String, ObjectKycEntity?>? objectKyc;

  KycEntity({
    // this.id,
    // this.name,
    this.objectKyc,
  });

  @override
  List<Object?> get props => [objectKyc];
}
