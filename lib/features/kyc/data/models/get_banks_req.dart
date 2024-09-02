class GetBanksReq {
  final int? limit;
  final int? page;
  final String? sortBy;

  GetBanksReq({
    this.limit,
    this.page,
    this.sortBy,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['limit'] = limit;
    data['page'] = page;
    data['sort_by'] = sortBy;
    return data;
  }
}
