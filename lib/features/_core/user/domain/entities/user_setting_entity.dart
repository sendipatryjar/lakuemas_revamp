import 'package:equatable/equatable.dart';

class UserSettingEntity extends Equatable {
  final bool withPrice;
  final bool withPromo;

  const UserSettingEntity({required this.withPrice, required this.withPromo});

  @override
  List<Object?> get props => [withPrice, withPromo];
}
