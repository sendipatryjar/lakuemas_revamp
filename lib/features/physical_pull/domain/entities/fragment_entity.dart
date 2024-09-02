import 'package:equatable/equatable.dart';

class FragmentEntity extends Equatable {
  final int? id;
  final int? goldBrandId;
  final double? fragment;
  final int? certificatePrice;

  const FragmentEntity({
    this.id,
    this.goldBrandId,
    this.fragment,
    this.certificatePrice,
  });

  @override
  List<Object?> get props => [id, goldBrandId, fragment, certificatePrice];
}
