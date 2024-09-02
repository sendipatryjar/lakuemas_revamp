import '../../domain/entities/user_favorite_entity.dart';

class UserFavoriteModel extends UserFavoriteEntity {
  const UserFavoriteModel({
    String? accountName,
    String? accountNumber,
  }) : super(
          accountName: accountName,
          accountNumber: accountNumber,
        );

  static UserFavoriteModel fromJson(Map<String, dynamic> json) {
    return UserFavoriteModel(
      accountName: json['account_name'],
      accountNumber: json['account_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    return data;
  }
}
