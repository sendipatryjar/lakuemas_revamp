class TrxHistoryReq {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;
  final int? status;
  final String? type;

  const TrxHistoryReq({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
    this.status,
    this.type,
  });

  // Map<String, dynamic> toJson() {
  //   return {

  //   }
  // }

  TrxHistoryReq copyWith({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    int? status,
    String? type,
  }) =>
      TrxHistoryReq(
        limit: limit ?? this.limit,
        page: page ?? this.page,
        sortBy: sortBy ?? this.sortBy,
        orderBy: orderBy ?? this.orderBy,
        status: status ?? this.status,
        type: type ?? this.type,
      );
}
