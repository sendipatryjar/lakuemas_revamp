import '../../domain/entities/pin_entity.dart';

class PinModel extends PinEntity {
  const PinModel({
    String? accessToken,
    String? refreshToken,
    int? exp,
    int? iat,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          exp: exp,
          iat: iat,
        );

  static PinModel fromJson(Map<String, dynamic> json) => PinModel(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        exp: json['exp'],
        iat: json['iat'],
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'exp': exp,
        'iat': iat,
      };
}
