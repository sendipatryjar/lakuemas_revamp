import 'package:equatable/equatable.dart';

class LakusaveDurationEntity extends Equatable {
  final int? id;
  final String? type;
  final int? duration;

  const LakusaveDurationEntity({this.id, this.type, this.duration});

  @override
  List<Object?> get props => [id, type, duration];
}
