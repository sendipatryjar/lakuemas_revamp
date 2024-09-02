import 'package:equatable/equatable.dart';

class AccountBalanceFaqEntity extends Equatable {
  final String? question;
  final String? answer;

  const AccountBalanceFaqEntity({
    this.question,
    this.answer,
  });

  @override
  List<Object?> get props => [question, answer];
}
