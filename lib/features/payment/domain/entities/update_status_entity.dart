import 'package:equatable/equatable.dart';

class UpdateStatusEntity extends Equatable {
  final int? id;
  final int? customerId;
  final int? status;
  final String? code;
  final String? type;
  final String? statusLabel;

  const UpdateStatusEntity(
      {this.id,
      this.customerId,
      this.status,
      this.code,
      this.type,
      this.statusLabel});

  @override
  List<Object?> get props => [
        id,
        customerId,
        status,
        code,
        type,
        statusLabel,
      ];
}
