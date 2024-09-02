part of 'detail_district_bloc.dart';

abstract class DetailDistrictEvent extends Equatable {
  const DetailDistrictEvent();

  @override
  List<Object> get props => [];
}

class DetailDistrictGetEvent extends DetailDistrictEvent {
  final int? id;
  final HelperDataCubit helperDataCubit;

  const DetailDistrictGetEvent({
    this.id,
    required this.helperDataCubit,
  });

  @override
  List<Object> get props => [
        [id, helperDataCubit]
      ];
}

class DetailDistrictMailGetEvent extends DetailDistrictEvent {
  final int? id;
  final HelperDataCubit helperDataCubit;

  const DetailDistrictMailGetEvent({
    this.id,
    required this.helperDataCubit,
  });

  @override
  List<Object> get props => [
        [id, helperDataCubit]
      ];
}
