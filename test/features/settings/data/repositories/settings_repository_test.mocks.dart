// Mocks generated by Mockito 5.4.4 from annotations
// in lakuemas/test/features/settings/data/repositories/settings_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:lakuemas/cores/models/base_resp.dart' as _i2;
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart'
    as _i3;
import 'package:lakuemas/features/settings/data/data_sources/interfaces/i_settings_remote_data_source.dart'
    as _i5;
import 'package:lakuemas/features/settings/data/models/update_settings_req.dart'
    as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBaseResp_0<T> extends _i1.SmartFake implements _i2.BaseResp<T> {
  _FakeBaseResp_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ITokenLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockITokenLocalDataSource extends _i1.Mock
    implements _i3.ITokenLocalDataSource {
  MockITokenLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> saveAccessToken(String? accToken) => (super.noSuchMethod(
        Invocation.method(
          #saveAccessToken,
          [accToken],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<String?> getAccessToken() => (super.noSuchMethod(
        Invocation.method(
          #getAccessToken,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);

  @override
  _i4.Future<void> saveRefreshToken(String? refreshToken) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveRefreshToken,
          [refreshToken],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<String?> getRefreshToken() => (super.noSuchMethod(
        Invocation.method(
          #getRefreshToken,
          [],
        ),
        returnValue: _i4.Future<String?>.value(),
      ) as _i4.Future<String?>);
}

/// A class which mocks [ISettingsRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockISettingsRemoteDataSource extends _i1.Mock
    implements _i5.ISettingsRemoteDataSource {
  @override
  _i4.Future<_i2.BaseResp<dynamic>> updateSettings({
    String? accessToken,
    String? refreshToken,
    _i6.UpdateSettingsReq? request,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSettings,
          [],
          {
            #accessToken: accessToken,
            #refreshToken: refreshToken,
            #request: request,
          },
        ),
        returnValue:
            _i4.Future<_i2.BaseResp<dynamic>>.value(_FakeBaseResp_0<dynamic>(
          this,
          Invocation.method(
            #updateSettings,
            [],
            {
              #accessToken: accessToken,
              #refreshToken: refreshToken,
              #request: request,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.BaseResp<dynamic>>.value(_FakeBaseResp_0<dynamic>(
          this,
          Invocation.method(
            #updateSettings,
            [],
            {
              #accessToken: accessToken,
              #refreshToken: refreshToken,
              #request: request,
            },
          ),
        )),
      ) as _i4.Future<_i2.BaseResp<dynamic>>);
}
