class GetTransactionsReq {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;
  final int? status;
  final String? type;

  GetTransactionsReq({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
    this.status,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        ...(limit != null ? {'limit': limit} : {}),
        ...(page != null ? {'page': page} : {}),
        ...(sortBy != null ? {'sort_by': sortBy} : {}),
        ...(orderBy != null ? {'order_by': orderBy} : {}),
        ...(status != null ? {'status': status} : {}),
        ...(type != null ? {'type': type} : {}),
      };
}
