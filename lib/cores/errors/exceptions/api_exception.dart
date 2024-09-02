class ClientException implements Exception {
  final int? code;
  final String? message;
  final Map<String, dynamic>? errors;
  ClientException(this.code, this.message, this.errors);

  @override
  String toString() {
    if (message == null) return "Exception";
    return message!;
  }
}

class ServerException implements Exception {
  final bool isTimeout;
  ServerException(this.isTimeout);

  @override
  String toString() {
    return isTimeout.toString();
  }
}

class RequestCancelledException implements Exception {}

class SessionException implements Exception {}

class UnknownException implements Exception {
  final String? message;

  UnknownException(this.message);
  @override
  String toString() {
    return message ?? '';
  }
}
