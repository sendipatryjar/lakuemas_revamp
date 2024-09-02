import 'package:equatable/equatable.dart';

class SocialMediaConfigEntity extends Equatable {
  final String? text;
  final String? image;

  const SocialMediaConfigEntity({
    this.text,
    this.image,
  });

  @override
  List<Object?> get props => [text, image];
}
