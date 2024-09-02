import 'package:equatable/equatable.dart';

class TermsAndConditionsEntity extends Equatable {
  final String? title;
  final String? description;

  const TermsAndConditionsEntity({this.title, this.description});

  @override
  List<Object?> get props => [title, description];
}
