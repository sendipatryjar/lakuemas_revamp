import '../../domain/entities/list_gold_brand_entity.dart';
import 'fragment_gold_brand_model.dart';

class ListGoldBrandModel extends ListGoldBrandEntity {
  const ListGoldBrandModel({
    int? isActiveFeCus,
    int? isActiveFeBus,
    int? id,
    String? brand,
    String? label,
    String? image,
    String? imageNew,
    List<FragmentGoldBrandModel>? fragments,
  }) : super(
          isActiveFeCus: isActiveFeCus,
          isActiveFeBus: isActiveFeBus,
          id: id,
          brand: brand,
          label: label,
          image: image,
          imageNew: imageNew,
          fragments: fragments,
        );

  static ListGoldBrandModel fromJson(Map<String, dynamic> json) {
    List<FragmentGoldBrandModel>? fragmentEntity;
    if (json['fragments'] != null) {
      fragmentEntity = <FragmentGoldBrandModel>[];
      json['fragments'].forEach((v) {
        fragmentEntity!.add(FragmentGoldBrandModel.fromJson(v));
      });
    }

    return ListGoldBrandModel(
      isActiveFeCus: json["is_active_fe_customer"],
      isActiveFeBus: json["is_active_fe_business"],
      id: json["id"],
      brand: json["brand"],
      label: json["label"],
      image: json["image"],
      imageNew: json["image_new"],
      fragments: fragmentEntity,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["is_active_fe_customer"] = isActiveFeCus;
    data["is_active_fe_business"] = isActiveFeBus;
    data["id"] = id;
    data["brand"] = brand;
    data["label"] = label;
    data["image"] = image;
    data["image_new"] = imageNew;
    if (fragments != null) {
      data["fragments"] = fragments!.map((e) => FragmentGoldBrandModel(
            id: e.id,
            goldBrandId: e.goldBrandId,
            fragment: e.fragment,
            certificatePrice: e.certificatePrice,
          ));
    }

    return data;
  }
}
