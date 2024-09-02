import 'package:equatable/equatable.dart';

class LanguageEntity extends Equatable {
  final String? code;
  final String? flag;
  final String? flagAsset;
  final String? name;

  const LanguageEntity({this.code, this.flag, this.flagAsset, this.name});

  @override
  List<Object?> get props => [code, flag, flagAsset, name];

  @override
  String toString() {
    return '\'code\':\'$code\'';
  }
}
