import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final String? imageUrl;

  const PromoEntity({this.id, this.title, this.content, this.imageUrl});

  @override
  List<Object?> get props => [id, title, content, imageUrl];
}
