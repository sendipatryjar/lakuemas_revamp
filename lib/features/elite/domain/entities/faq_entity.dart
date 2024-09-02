import 'package:equatable/equatable.dart';

class FaqEntity extends Equatable {
  final int? id;
  final int? sequence;
  final int? isactive;
  final String? question;
  final String? answer;

  const FaqEntity({
    this.id,
    this.sequence,
    this.isactive,
    this.question,
    this.answer,
  });

  @override
  List<Object?> get props => [
        id,
        sequence,
        isactive,
        question,
        answer,
      ];
}
