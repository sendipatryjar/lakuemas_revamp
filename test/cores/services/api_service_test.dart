import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late MockHttpClientAdapter tokenDioAdapterMock;
  late Dio dio;
  late Dio tokenDio;
  late ApiService apiService;

  setUpAll(() {
    dio = Dio();
    tokenDio = Dio();
    dioAdapterMock = MockHttpClientAdapter();
    tokenDioAdapterMock = MockHttpClientAdapter();
    dio.httpClientAdapter = dioAdapterMock;
    tokenDio.httpClientAdapter = tokenDioAdapterMock;
    apiService = ApiService(
      dio: dio,
      tokenDio: tokenDio,
      secureStorageService: SecureStorageService(),
      isForTest: true,
    );
  });

  group(
    'api service',
    () {
      late String responsepayload;
      late ResponseBody httpResponse;
      setUp(() {
        responsepayload = jsonEncode({"response_code": "1000"});
        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      test(
        'GET',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await apiService.baseUrl('http://192.168.10.5:8082').get(
                    apiPath: '',
                  );

          expect(result, isNotNull);
          expect(result, isA<Response>());
        },
      );
      test(
        'POST',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await apiService.baseUrl('http://192.168.10.5:8082').post(
                    apiPath: '',
                  );

          expect(result, isNotNull);
          expect(result, isA<Response>());
        },
      );

      test(
        'POST LIST',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await apiService.baseUrl('http://192.168.10.5:8082').postList(
                    apiPath: '',
                  );

          expect(result, isNotNull);
          expect(result, isA<Response>());
        },
      );

      test(
        'PUT',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await apiService.baseUrl('http://192.168.10.5:8082').put(
                    apiPath: '',
                  );

          expect(result, isNotNull);
          expect(result, isA<Response>());
        },
      );

      test(
        'DELETE',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await apiService.baseUrl('http://192.168.10.5:8082').delete(
                    apiPath: '',
                  );

          expect(result, isNotNull);
          expect(result, isA<Response>());
        },
      );
    },
  );
}
