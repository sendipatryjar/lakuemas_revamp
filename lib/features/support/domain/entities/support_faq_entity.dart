import 'package:equatable/equatable.dart';

class SupportFaqEntity extends Equatable {
  final String? title;
  final List<SupportFaqItemEntity>? items;

  const SupportFaqEntity({this.title, this.items});

  @override
  List<Object?> get props => [title, items];
}

class SupportFaqItemEntity extends Equatable {
  final String? question;
  final String? answer;

  const SupportFaqItemEntity({this.question, this.answer});

  @override
  List<Object?> get props => [question, answer];
}
