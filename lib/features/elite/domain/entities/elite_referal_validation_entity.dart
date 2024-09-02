import 'package:equatable/equatable.dart';

class EliteReferalValidaitonEntity extends Equatable {
  final bool? isValid;
  final String? referalCode;
  final String? referalName;

  const EliteReferalValidaitonEntity(
      {this.isValid, this.referalCode, this.referalName});

  @override
  List<Object?> get props => [
        [
          isValid,
          referalCode,
          referalName,
        ]
      ];
}
