import 'package:equatable/equatable.dart';

import '../../../../kyc/domain/entities/kyc_entity.dart';
import 'user_data_address_entity.dart';
import 'user_favorite_entity.dart';
import 'user_setting_entity.dart';

class UserDataEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final String? handphone;
  final String? gender;
  final String? countryOfBirth;
  final String? placeOfBirth;
  final String? dateOfBirth;
  final String? maritalStatus;
  final String? religion;
  final String? occupation;
  final String? income;
  final String? purpose;
  final String? avatarUrl;
  final bool? pinStatus;
  final bool? isElite;
  final int? customerTypeId;
  final int? isEmailVerified;
  final int? isPhoneNumberVerified;
  final int? unreadNotifications;
  final List<UserDataAddressEntity>? userDataAddressEntity;
  final UserSettingEntity? userSettingEntity;
  final KycEntity? kycEntity;
  final List<UserFavoriteEntity>? userFavoritesEntity;

  const UserDataEntity({
    this.id,
    this.name,
    this.email,
    this.handphone,
    this.gender,
    this.countryOfBirth,
    this.placeOfBirth,
    this.dateOfBirth,
    this.maritalStatus,
    this.religion,
    this.occupation,
    this.income,
    this.purpose,
    this.avatarUrl,
    this.pinStatus,
    this.isElite,
    this.customerTypeId,
    this.isEmailVerified,
    this.isPhoneNumberVerified,
    this.unreadNotifications,
    this.userDataAddressEntity,
    this.userSettingEntity,
    this.kycEntity,
    this.userFavoritesEntity,
  });

  @override
  List<Object> get props => [
        [
          id,
          name,
          email,
          handphone,
          gender,
          countryOfBirth,
          placeOfBirth,
          dateOfBirth,
          maritalStatus,
          religion,
          occupation,
          income,
          purpose,
          avatarUrl,
          pinStatus,
          isElite,
          customerTypeId,
          isEmailVerified,
          isPhoneNumberVerified,
          unreadNotifications,
          userDataAddressEntity,
          userSettingEntity,
          kycEntity,
          userFavoritesEntity,
        ]
      ];
}
