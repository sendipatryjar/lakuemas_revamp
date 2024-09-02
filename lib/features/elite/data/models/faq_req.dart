class FaqReq {
  final String? sortBy;
  final String? orderBy;
  final int? isActive;

  FaqReq({
    this.sortBy,
    this.orderBy,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['sort_by'] = sortBy;
    data['order_by'] = orderBy;
    data['is_active'] = isActive;
    return data;
  }
}
