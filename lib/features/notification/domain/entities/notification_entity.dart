import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int? id;
  final int? customerId;
  final int? articleId;
  final int? promoId;
  final int? isRead;
  final String? transactionCode;
  final String? title;
  final String? body;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const NotificationEntity({
    this.id,
    this.customerId,
    this.articleId,
    this.promoId,
    this.isRead,
    this.transactionCode,
    this.title,
    this.body,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  NotificationEntity copyWith({
    int? isRead,
  }) =>
      NotificationEntity(
        id: id,
        customerId: customerId,
        articleId: articleId,
        promoId: promoId,
        isRead: isRead ?? this.isRead,
        transactionCode: transactionCode,
        title: title,
        body: body,
        imageUrl: imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        customerId,
        articleId,
        promoId,
        isRead,
        transactionCode,
        title,
        body,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}
