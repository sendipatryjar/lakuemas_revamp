import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    int? id,
    int? customerId,
    int? articleId,
    int? promoId,
    int? isRead,
    String? transactionCode,
    String? title,
    String? body,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          customerId: customerId,
          articleId: articleId,
          promoId: promoId,
          isRead: isRead,
          transactionCode: transactionCode,
          title: title,
          body: body,
          imageUrl: imageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  NotificationModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'],
          customerId: json['customer_id'],
          articleId: json['article_id'],
          promoId: json['promo_id'],
          isRead: json['is_read'],
          transactionCode: json['transaction_code'],
          title: json['title'],
          body: json['body'],
          imageUrl: json['image_url'],
          createdAt: json['created_at'],
          updatedAt: json['updated_at'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = super.id;
    data['customer_id'] = super.customerId;
    data['article_id'] = super.articleId;
    data['promo_id'] = super.promoId;
    data['is_read'] = super.isRead;
    data['transaction_code'] = super.transactionCode;
    data['title'] = super.title;
    data['body'] = super.body;
    data['image_url'] = super.imageUrl;
    data['created_at'] = super.createdAt;
    data['updated_at'] = super.updatedAt;
    return data;
  }
}
