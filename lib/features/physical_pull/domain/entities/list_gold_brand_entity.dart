import 'package:equatable/equatable.dart';

import 'fragment_entity.dart';

class ListGoldBrandEntity extends Equatable {
  final int? isActiveFeCus;
  final int? isActiveFeBus;
  final int? id;
  final String? brand;
  final String? label;
  final String? image;
  final String? imageNew;
  final List<FragmentEntity>? fragments;

  const ListGoldBrandEntity({
    this.isActiveFeCus,
    this.isActiveFeBus,
    this.id,
    this.brand,
    this.label,
    this.image,
    this.imageNew,
    this.fragments,
  });

  @override
  List<Object?> get props => [
        [
          isActiveFeCus,
          isActiveFeBus,
          id,
          brand,
          label,
          image,
          imageNew,
          fragments,
        ],
      ];
}
