import '../../../../kyc/data/models/kyc_data_model.dart';
import '../../../../kyc/data/models/object_kyc_model.dart';
import '../../domain/entities/user_data_entity.dart';
import 'user_data_address_model.dart';
import 'user_favorite_model.dart';
import 'user_setting_model.dart';

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    int? id,
    String? name,
    String? email,
    String? handphone,
    String? gender,
    String? countryOfBirth,
    String? placeOfBirth,
    String? dateOfBirth,
    String? maritalStatus,
    String? religion,
    String? occupation,
    String? income,
    String? purpose,
    String? avatarUrl,
    bool? pinStatus,
    bool? isElite,
    int? customerTypeId,
    int? isEmailVerified,
    int? isPhoneNumberVerified,
    int? unreadNotifications,
    List<UserDataAddressModel>? userDataAddressModel,
    UserSettingModel? userSettingModel,
    KycDataModel? kycDataModel,
    List<UserFavoriteModel>? userFavoriteModel,
  }) : super(
          id: id,
          name: name,
          email: email,
          handphone: handphone,
          gender: gender,
          countryOfBirth: countryOfBirth,
          placeOfBirth: placeOfBirth,
          dateOfBirth: dateOfBirth,
          maritalStatus: maritalStatus,
          religion: religion,
          occupation: occupation,
          income: income,
          purpose: purpose,
          avatarUrl: avatarUrl,
          pinStatus: pinStatus,
          isElite: isElite,
          customerTypeId: customerTypeId,
          isEmailVerified: isEmailVerified,
          isPhoneNumberVerified: isPhoneNumberVerified,
          unreadNotifications: unreadNotifications,
          userDataAddressEntity: userDataAddressModel,
          userSettingEntity: userSettingModel,
          kycEntity: kycDataModel,
          userFavoritesEntity: userFavoriteModel,
        );

  static UserDataModel fromJson(Map<String, dynamic> json) {
    List<UserDataAddressModel>? userDataAddressEntity;
    if (json['customer_address'] != null) {
      userDataAddressEntity = <UserDataAddressModel>[];
      json['customer_address'].forEach((v) {
        userDataAddressEntity!.add(UserDataAddressModel.fromJson(v));
      });
    }
    List<UserFavoriteModel>? userFavoriteEntity;
    if (json['favorites_gold_savings'] != null) {
      userFavoriteEntity = <UserFavoriteModel>[];
      json['favorites_gold_savings'].forEach((v) {
        userFavoriteEntity!.add(UserFavoriteModel.fromJson(v));
      });
    }
    return UserDataModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      handphone: json['handphone'],
      gender: json['gender'],
      countryOfBirth: json['country_of_birth'],
      placeOfBirth: json['place_of_birth'],
      dateOfBirth: json['date_of_birth'],
      maritalStatus: json['marital_status'],
      religion: json['religion'],
      occupation: json['occupation'],
      income: json['income'],
      purpose: json['purpose'],
      avatarUrl: json['avatar_url'],
      pinStatus: json['pin_status'],
      isElite: json['is_elite'],
      customerTypeId: json['customer_type_id'],
      isEmailVerified: json['is_email_verified'],
      isPhoneNumberVerified: json['is_phone_number_verified'],
      // isEmailVerified: 0,
      // isPhoneNumberVerified: 1,
      unreadNotifications: json['unread_notifications'],
      userDataAddressModel: userDataAddressEntity,
      userSettingModel: json['customer_setting'] != null
          ? UserSettingModel.fromJson(json['customer_setting'])
          : null,
      kycDataModel: json['kyc_data'] != null
          ? KycDataModel.fromJson(json['kyc_data'])
          : null,
      userFavoriteModel: userFavoriteEntity,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['handphone'] = handphone;
    data['gender'] = gender;
    data['country_of_birth'] = countryOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['date_of_birth'] = dateOfBirth;
    data['marital_status'] = maritalStatus;
    data['religion'] = religion;
    data['occupation'] = occupation;
    data['income'] = income;
    data['purpose'] = purpose;
    data['avatar_url'] = avatarUrl;
    data['pin_status'] = pinStatus;
    data['is_elite'] = isElite;
    data['customer_type_id'] = customerTypeId;
    data['is_email_verified'] = isEmailVerified;
    data['is_phone_number_verified'] = isPhoneNumberVerified;
    data['unread_notifications'] = unreadNotifications;
    if (userDataAddressEntity != null) {
      data['customer_address'] = userDataAddressEntity!
          .map((v) => UserDataAddressModel(
                address: v.address,
                type: v.type,
                districtId: v.districtId,
                postalCode: v.postalCode,
              ).toJson())
          .toList();
    }
    if (userSettingEntity != null) {
      data['customer_setting'] = UserSettingModel(
        withPrice: userSettingEntity?.withPrice,
        withPromo: userSettingEntity?.withPromo,
      ).toJson();
    }
    if (kycEntity != null) {
      data['kyc_data'] = KycDataModel(
        // id: kycEntity?.id,
        // name: kycEntity?.name,
        objectKyc: kycEntity?.objectKyc?.map((key, value) => MapEntry(
            key,
            ObjectKycModel(
              bankId: value?.bankId,
              status: value?.status,
              number: value?.number,
              name: value?.name,
              pob: value?.pob,
              dob: value?.dob,
              imageUrl: value?.imageUrl,
              reason: value?.reason,
            ))),
      ).toJson();
    }
    if (userFavoritesEntity != null) {
      data['favorites_gold_savings'] = userFavoritesEntity!
          .map((v) => UserFavoriteModel(
                accountName: v.accountName,
                accountNumber: v.accountNumber,
              ).toJson())
          .toList();
    }
    return data;
  }
}
