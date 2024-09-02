import 'package:equatable/equatable.dart';

class UserFavoriteEntity extends Equatable {
  final String? accountName;
  final String? accountNumber;

  const UserFavoriteEntity({this.accountName, this.accountNumber});

  @override
  List<Object?> get props => [accountName, accountNumber];
}
