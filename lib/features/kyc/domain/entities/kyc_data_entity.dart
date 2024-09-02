import 'package:equatable/equatable.dart';

class KycDataEntity extends Equatable {
  final int? status;
  final String? number;
  final String? imageUrl;

  const KycDataEntity({
    required this.status,
    required this.number,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [status, number, imageUrl];
}
