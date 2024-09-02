import 'package:equatable/equatable.dart';

class DataWithMeta<T> extends Equatable {
  final T data;
  final Map<String, dynamic> _meta;

  MetaDataApi? get meta => MetaDataApi.fromJson(_meta);

  const DataWithMeta(this.data, this._meta);

  @override
  List<Object?> get props => [data, meta];
}

class MetaDataApi extends Equatable {
  final int? limit;
  final int? page;
  final int? totalPage;
  final int? totalCount;

  const MetaDataApi({this.limit, this.page, this.totalPage, this.totalCount});

  factory MetaDataApi.fromJson(Map<String, dynamic> json) => MetaDataApi(
        limit: json['limit'],
        page: json['page'],
        totalPage: json['total_page'],
        totalCount: json['total_count'],
      );

  @override
  List<Object?> get props => [limit, page, totalPage, totalCount];
}
