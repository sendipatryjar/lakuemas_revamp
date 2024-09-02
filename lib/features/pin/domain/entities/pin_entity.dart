import 'package:equatable/equatable.dart';

class PinEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? exp;
  final int? iat;

  const PinEntity({this.accessToken, this.refreshToken, this.exp, this.iat});

  @override
  List<Object?> get props => [accessToken, refreshToken, exp, iat];
}
