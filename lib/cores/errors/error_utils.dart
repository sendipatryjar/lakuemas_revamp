import 'package:dio/dio.dart' as dio;

import 'exceptions/api_exception.dart';

handleErrors(dio.Response response) {
  if (response.statusCode == null && response.data['code'] == null) {
    throw RequestCancelledException();
  } else if (response.statusCode == 401) {
    throw SessionException();
  } else {
    if (response.statusCode.toString().startsWith('4')) {
      throw ClientException(
        response.data['code'],
        response.data['message'] != null ? "${response.data['message']}" : null,
        response.data['errors'],
      );
    } else if (response.statusCode.toString().startsWith('5')) {
      throw ServerException(false);
    } else {
      throw UnknownException(response.statusMessage);
    }
  }
}
