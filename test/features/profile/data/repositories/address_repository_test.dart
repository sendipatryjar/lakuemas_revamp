import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/profile/data/data_sources/interfaces/i_address_remote_data_source.dart';
import 'package:lakuemas/features/profile/data/models/address_req.dart';
import 'package:lakuemas/features/profile/data/models/get_city_model.dart';
import 'package:lakuemas/features/profile/data/models/get_district_model.dart';
import 'package:lakuemas/features/profile/data/models/get_province_model.dart';
import 'package:lakuemas/features/profile/data/repositories/address_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
], customMocks: [
  MockSpec<IAddressRemoteDataSource>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  late MockIAddressRemoteDataSource mockIAddressRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late AddressRepository addressRepository;

  setUpAll(() {
    mockIAddressRemoteDataSource = MockIAddressRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    addressRepository = AddressRepository(
      remoteDataSource: mockIAddressRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group(
    'Address Repository',
    () {
      group('get provinces', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
        late AddressReq addressReq;
        late List<GetProvinceModel> data;
        setUp(
          () {
            addressReq = const AddressReq(
              limit: 10,
              page: 1,
              orderBy: 'name',
              sortBy: 'name',
            );
            data = [
              const GetProvinceModel(
                id: 1,
                name: 'DKI Jakarta',
                createdAt: '',
                updatedAt: '',
              ),
              const GetProvinceModel(
                id: 2,
                name: 'Jawa Barat',
                createdAt: '',
                updatedAt: '',
              ),
            ];
          },
        );
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getProvinces(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenAnswer(
                (realInvocation) async => BaseListResp<GetProvinceModel>(
                      code: 200,
                      msgKey: 'SUCCESS',
                      message: 'SUCCESS',
                      data: data,
                    ));

            final result = await addressRepository.getProvinces(
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, Right<AppFailure, List<GetProvinceModel>>(data));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getProvinces(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(SessionException());

            final result = await addressRepository.getProvinces(
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getProvinces(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await addressRepository.getProvinces(
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getProvinces(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(ServerException(false));

            final result = await addressRepository.getProvinces(
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getProvinces(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await addressRepository.getProvinces(
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('get Cities', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
        late AddressReq addressReq;
        late List<GetCityModel> data;
        setUp(
          () {
            addressReq = const AddressReq(
              provinceId: 1,
              limit: 10,
              page: 1,
              orderBy: 'name',
              sortBy: 'name',
            );
            data = [
              const GetCityModel(
                provinceId: 1,
                id: 1,
                city: 'Jakarta',
                createdAt: '',
                updatedAt: '',
              ),
              const GetCityModel(
                provinceId: 2,
                id: 1,
                city: 'Bandung',
                createdAt: '',
                updatedAt: '',
              ),
            ];
          },
        );
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getCities(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenAnswer((realInvocation) async => BaseListResp<GetCityModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                  data: data,
                ));

            final result = await addressRepository.getCities(
              provinceId: addressReq.provinceId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, Right<AppFailure, List<GetCityModel>>(data));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getCities(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(SessionException());

            final result = await addressRepository.getCities(
              provinceId: addressReq.provinceId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getCities(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await addressRepository.getCities(
              provinceId: addressReq.provinceId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getCities(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(ServerException(false));

            final result = await addressRepository.getCities(
              provinceId: addressReq.provinceId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getCities(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await addressRepository.getCities(
              provinceId: addressReq.provinceId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('get Districts', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
        late AddressReq addressReq;
        late List<GetDistrictModel> data;
        setUp(
          () {
            addressReq = const AddressReq(
              cityId: 1,
              limit: 10,
              page: 1,
              orderBy: 'name',
              sortBy: 'name',
            );
            data = [
              const GetDistrictModel(
                cityId: 1,
                id: 1,
                name: 'Jakarta Selatan',
                createdAt: '',
                updatedAt: '',
              ),
              const GetDistrictModel(
                cityId: 1,
                id: 2,
                name: 'Bandung',
                createdAt: '',
                updatedAt: '',
              ),
            ];
          },
        );
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getDistricts(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenAnswer(
                (realInvocation) async => BaseListResp<GetDistrictModel>(
                      code: 200,
                      msgKey: 'SUCCESS',
                      message: 'SUCCESS',
                      data: data,
                    ));

            final result = await addressRepository.getDistricts(
              cityId: addressReq.cityId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, Right<AppFailure, List<GetDistrictModel>>(data));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getDistricts(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(SessionException());

            final result = await addressRepository.getDistricts(
              cityId: addressReq.cityId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getDistricts(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await addressRepository.getDistricts(
              cityId: addressReq.cityId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getDistricts(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(ServerException(false));

            final result = await addressRepository.getDistricts(
              cityId: addressReq.cityId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIAddressRemoteDataSource.getDistricts(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: addressReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await addressRepository.getDistricts(
              cityId: addressReq.cityId,
              limit: addressReq.limit,
              page: addressReq.page,
              orderBy: addressReq.orderBy,
              sortBy: addressReq.sortBy,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });
    },
  );
}
