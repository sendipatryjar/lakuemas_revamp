class BaseListResp<T> {
  int? code;
  String? msgKey;
  String? message;
  final List<T>? data;
  Map<String, dynamic>? meta;
  Map<String, dynamic>? errors;

  BaseListResp({
    this.code,
    this.msgKey,
    this.message,
    this.data,
    this.meta,
    this.errors,
  });

  BaseListResp.fromJson(dynamic json, Function fromJsonModel)
      : code = json['code'] is int? ? json['code'] : int.tryParse(json['code']),
        msgKey = json['msg_key'],
        message = json['message'],
        data = json['data'] != null
            ? List<T>.from(json['data']
                .cast<Map<String, dynamic>>()
                .map((itemsJson) => fromJsonModel(itemsJson)))
            : null,
        meta = json['meta'],
        errors = json['errors'];
}
