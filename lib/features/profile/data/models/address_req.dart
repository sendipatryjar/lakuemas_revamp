import 'package:equatable/equatable.dart';

class AddressReq extends Equatable {
  final int? limit;
  final int? page;
  final int? provinceId;
  final int? cityId;
  final String? sortBy;
  final String? orderBy;
  final String? keyword;

  const AddressReq({
    this.limit,
    this.page,
    this.provinceId,
    this.cityId,
    this.sortBy,
    this.orderBy,
    this.keyword,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['page'] = page;
    if (provinceId != null) {
      data['province_id'] = provinceId;
    }
    if (cityId != null) {
      data['city_id'] = cityId;
    }
    data['sort_by'] = sortBy;
    data['order_by'] = orderBy;
    if (keyword != null) {
      data['keyword'] = keyword;
    }
    return data;
  }

  @override
  List<Object?> get props =>
      [limit, page, provinceId, cityId, sortBy, orderBy, keyword];
}
