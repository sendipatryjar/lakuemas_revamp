class BaseResp<T> {
  int? code;
  String? msgKey;
  String? message;
  T? data;
  Map<String, dynamic>? meta;
  Map<String, dynamic>? errors;

  BaseResp({
    this.code,
    this.msgKey,
    this.message,
    this.data,
    this.meta,
    this.errors,
  });

  BaseResp.fromJson(Map<String, dynamic> json, Function? fromJsonModel,
      [Map<String, dynamic>? dataPlaced]) {
    var dataPlacedJson = dataPlaced ?? json['data'];
    code = json['code'] is int? ? json['code'] : int.tryParse(json['code']);
    msgKey = json['msg_key'];
    message = json['message'];
    data = fromJsonModel != null
        ? dataPlacedJson != null
            ? fromJsonModel(dataPlacedJson)
            : null
        : null;
    meta = json['meta'];
    errors = json['errors'];
  }
}
