import '../../domain/entities/user_setting_entity.dart';

class UserSettingModel extends UserSettingEntity {
  const UserSettingModel({
    bool? withPrice,
    bool? withPromo,
  }) : super(
          withPrice: withPrice ?? false,
          withPromo: withPromo ?? false,
        );

  static UserSettingModel fromJson(Map<String, dynamic> json) {
    return UserSettingModel(
      withPrice: json['with_price'],
      withPromo: json['with_promo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['with_price'] = withPrice;
    data['with_promo'] = withPromo;
    return data;
  }
}
