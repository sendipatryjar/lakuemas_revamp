import 'package:equatable/equatable.dart';

class UpdateSettingsReq extends Equatable {
  final bool withPrice;
  final bool withPromo;

  const UpdateSettingsReq({required this.withPrice, required this.withPromo});

  Map<String, dynamic> toJson() {
    return {
      'with_price': withPrice,
      'with_promo': withPromo,
    };
  }

  @override
  List<Object?> get props => [withPrice, withPromo];
}
