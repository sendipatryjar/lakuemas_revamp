part of 'profile_address_update_bloc.dart';

abstract class ProfileAddressUpdateEvent extends Equatable {
  const ProfileAddressUpdateEvent();

  @override
  List<Object> get props => [];
}

class ProfileAddressUpdatePressed extends ProfileAddressUpdateEvent {
  final List<UpdateAddressEntity> datas;

  const ProfileAddressUpdatePressed(this.datas);

  @override
  List<Object> get props => [datas];
}
