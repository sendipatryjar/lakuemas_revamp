import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:go_router/go_router.dart';
import 'package:requests_inspector/requests_inspector.dart';

import '../configs/environment.dart';
import '../constants/api_path.dart';
import '../constants/secure_storage_key.dart';
import '../routes/app_navigation.dart';
import '../routes/app_routes.dart';
import '../utils/app_utils.dart';
import 'crashlytics_service.dart';
import 'secure_storage_service.dart';

class ApiService {
  final Dio dio;
  final Dio tokenDio;
  final SecureStorageService secureStorageService;
  final bool isForTest;
  CancelToken cancelToken = CancelToken();

  ApiService({
    required this.dio,
    required this.tokenDio,
    required this.secureStorageService,
    this.isForTest = false,
  }) {
    // _dio = Dio(
    //   BaseOptions(
    //     receiveDataWhenStatusError: true,
    //     // connectTimeout: 5000,
    //     // sendTimeout: 5000,
    //     // receiveTimeout: 5000,
    //   ),
    // );
    dio.options.receiveDataWhenStatusError = true;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.sendTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    if (isForTest != true) dio.interceptors.add(RequestsInspectorInterceptor());
    dio.options.receiveDataWhenStatusError = true;
    dio.options.headers.addAll({Headers.acceptHeader: 'application/json'});
    if (isForTest != true) {
      tokenDio.interceptors.add(RequestsInspectorInterceptor());
    }
    tokenDio.options.receiveDataWhenStatusError = true;
    tokenDio.options.headers.addAll({Headers.acceptHeader: 'application/json'});
  }

  ApiService baseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
    tokenDio.options.baseUrl = Environment.baseUrlMember();
    return this;
  }

  ApiService addOtherHeader({required Map<String, String> headers}) {
    dio.options.headers.addAll(headers);
    return this;
  }

  ApiService tokenBearer(String? accessToken, String? refreshToken) {
    dio.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (isForTest) {
            return handler.next(options);
          }
          if (accessToken == null || refreshToken == null) {
            var error = _tokenExpiredRelogin(
              requestOptions: options,
              errors: {
                'refresh_token_expired':
                    'your session has expired, please reloggin..'
              },
            );
            return handler.reject(error);
          }

          // check if tokens have already expired or not
          final isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
          final isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
          if (isRefreshTokenExpired) {
            appPrint('Refresh Token Expired: user must be relogin');
            var error = _tokenExpiredRelogin(
              requestOptions: options,
              errors: {
                'refresh_token_expired':
                    'your session has expired, please reloggin..'
              },
            );
            return handler.reject(error);
          }
          if (isAccessTokenExpired) {
            appPrint('Access Token Expired: calling refresh access token');
            final response = await _post(
              apiPath: ApiPath.refreshToken,
              dio: tokenDio,
              request: {
                'refresh_token': refreshToken,
              },
              useFormData: true,
            );
            final newAccessToken = response.data?['data']?['access_token'];
            final newRefreshToken = response.data?['data']?['refresh_token'];
            if (newAccessToken != null) {
              await secureStorageService.writeSecureData(
                key: ssAccessToken,
                value: newAccessToken,
              );
            }
            if (newRefreshToken != null) {
              await secureStorageService.writeSecureData(
                key: ssRefreshToken,
                value: newRefreshToken,
              );
            }
            appPrint("Old access token $accessToken");
            appPrint("New access token $newAccessToken");
            appPrint("Old refresh token $refreshToken");
            appPrint("New refresh token $newRefreshToken");
            options.headers["Authorization"] = "Bearer $newAccessToken";
          }

          return handler.next(options);
        },
        onResponse: (e, handler) {
          return handler.next(e);
        },
        onError: (err, handler) async {
          if (err.response?.statusCode == 401) {
            appPrint('Access Token Expired: calling refresh access token');
            final response = await _post(
              apiPath: ApiPath.refreshToken,
              dio: tokenDio,
              request: {
                'refresh_token': refreshToken,
              },
              useFormData: true,
            );
            if (response.statusCode == 200) {
              final newAccessToken = response.data?['data']?['access_token'];
              final newRefreshToken = response.data?['data']?['refresh_token'];
              if (newAccessToken != null) {
                await secureStorageService.writeSecureData(
                  key: ssAccessToken,
                  value: newAccessToken,
                );
              }
              if (newRefreshToken != null) {
                await secureStorageService.writeSecureData(
                  key: ssRefreshToken,
                  value: newRefreshToken,
                );
              }
              appPrint("Old access token $accessToken");
              appPrint("New access token $newAccessToken");
              appPrint("Old refresh token $refreshToken");
              appPrint("New refresh token $newRefreshToken");
              dio.options.headers["Authorization"] = "Bearer $accessToken";

              return handler.resolve(response);
            } else {
              appPrint('token has updated from be: user must be relogin');
              var error = _tokenExpiredRelogin(
                requestOptions: err.requestOptions,
                errors: {
                  'refresh_token_expired':
                      'your session has expired, please reloggin..'
                },
              );
              handler.next(error);
            }
          }
          return handler.next(err);
        },
      ),
    );
    return this;
  }

  Future<Response> get({
    required String apiPath,
    Map<String, dynamic>? request,
    bool useFormData = false,
    bool isUseCancelToken = true,
  }) async {
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : GET');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.get(
        apiPath,
        queryParameters: request,
        cancelToken: isUseCancelToken ? cancelToken : null,
      );
      appPrint('Success [METHOD GET] $apiPath');
      await appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'GET',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error: [METHOD GET] $apiPath: $e');
        appPrintError('Error: $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error: [METHOD GET] $apiPath: $e');
        appPrintError('Error: $apiPath: ${response.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> patch({
    required String apiPath,
    Map<String, dynamic>? request,
    bool useFormData = false,
    bool isUseCancelToken = true,
  }) async {
    dio.options.headers['Content-type'] = 'application/json; charset=UTF-8';
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : PATCH');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.patch(
        apiPath,
        data: useFormData ? FormData.fromMap(request!) : request,
        cancelToken: isUseCancelToken ? cancelToken : null,
      );
      appPrint('Success [METHOD PATCH] $apiPath');
      await appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'PATCH',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error: [METHOD PATCH] $apiPath: $e');
        appPrintError('Error: $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error: [METHOD PATCH] $apiPath: $e');
        appPrintError('Error: $apiPath: ${response.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> post({
    required String apiPath,
    Map<String, dynamic>? request,
    bool useFormData = false,
  }) async {
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : POST');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.post(
        apiPath,
        data: useFormData ? FormData.fromMap(request!) : request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD POST] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'POST',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> postList({
    required String apiPath,
    List<Map<String, dynamic>>? request,
  }) async {
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : POST');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.post(
        apiPath,
        data: request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD POST] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'POST',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> put({
    required String apiPath,
    Map<String, dynamic>? request,
    bool useFormData = false,
  }) async {
    appPrint('===> CALL API <===');
    if (useFormData) {
      dio.options.headers.addAll({
        'Content-Type': 'application/x-www-form-urlencoded',
      });
    }
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : PUT');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.put(
        apiPath,
        data: useFormData ? FormData.fromMap(request!) : request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD PUT] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'PUT',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error: [METHOD PUT] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error: [METHOD PUT] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> putList({
    required String apiPath,
    List<Map<dynamic, dynamic>>? request,
    bool useFormData = false,
  }) async {
    appPrint('===> CALL API <===');
    dio.options.headers.addAll({
      'Content-Type': useFormData
          ? 'application/x-www-form-urlencoded'
          : 'application/json',
    });
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : PUT');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.put(
        apiPath,
        data: useFormData
            ? request
                ?.map((e) => FormData.fromMap((e as Map<String, dynamic>)))
                .toList()
            : request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD PUT] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'PUT',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error: [METHOD PUT] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error: [METHOD PUT] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> delete({
    required String apiPath,
    Map<String, dynamic>? request,
    bool useFormData = false,
  }) async {
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : DELETE');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.delete(
        apiPath,
        data: useFormData ? FormData.fromMap(request!) : request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD DELETE] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'DELETE',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error: [METHOD DELETE] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error: [METHOD DELETE] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  Future<Response> _post({
    required String apiPath,
    required Dio dio,
    Map<String, dynamic>? request,
    bool useFormData = false,
  }) async {
    appPrint('===> CALL API <===');
    appPrint('URL : ${dio.options.baseUrl}$apiPath');
    appPrint('Method : POST');
    appPrint("Header : ${dio.options.headers}");
    appPrint("Request : $request");
    try {
      Response response;
      response = await dio.post(
        apiPath,
        data: useFormData ? FormData.fromMap(request!) : request,
        cancelToken: cancelToken,
      );
      appPrint('Success [METHOD POST] $apiPath');
      appLog('Success Response : ${response.data}');
      appPrint('---');
      return response;
    } on DioException catch (e, s) {
      CrashlyticService.sendErrorApi(
        exception: e,
        stackTrace: s,
        url: '${dio.options.baseUrl}$apiPath',
        method: 'POST',
        header: '${dio.options.headers}',
        request: '$request',
      );
      if (e.response?.data is Map) {
        (e.response?.data as Map).addAll(<String, dynamic>{
          "status": "error",
        });
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return e.response!;
      } else {
        Response response = Response(
          data: {
            "error": null,
            "message": "error",
          },
          requestOptions: e.requestOptions,
          statusCode: e.response?.statusCode,
        );
        if (cancelToken.isCancelled) {
          response = Response(
            data: {
              "error": null,
              "message": "request cancelled",
            },
            requestOptions: e.requestOptions,
            statusCode: e.response?.statusCode,
          );
        }
        appPrintError('Error : [METHOD POST] $apiPath: $e');
        appPrintError('Error : $apiPath: ${e.response?.data}');
        appPrintError('---');
        return response;
      }
    }
  }

  DioException _tokenExpiredRelogin({
    required RequestOptions requestOptions,
    Map<String, dynamic>? errors,
  }) {
    try {
      SecureStorageService()
          .logout(AppNavigation.rootNavigatorKey.currentContext!);
    } catch (e) {
      appPrint("failed to remove user data");
    }
    AppNavigation.rootNavigatorKey.currentContext?.goNamed(AppRoutes.login);
    final error = DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.unknown,
      response: Response(
        requestOptions: requestOptions,
        statusCode: 4000,
        data: {
          'code': 4000,
          'msg_key': 'FAILED FROM MOBILE',
          'message': 'session expired, please relogin',
          'errors': errors,
        },
      ),
    );
    return error;
  }
}
