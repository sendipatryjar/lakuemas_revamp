// Mocks generated by Mockito 5.4.4 from annotations
// in lakuemas/test/features/forgot/data/repositories/forgot_password_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:lakuemas/cores/models/base_resp.dart' as _i2;
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart'
    as _i8;
import 'package:lakuemas/features/forgot/data/data_sources/interfaces/i_forgot_password_remote_data_source.dart'
    as _i3;
import 'package:lakuemas/features/forgot/data/models/verify_otp_forgot_model.dart'
    as _i6;
import 'package:lakuemas/features/otp/data/models/send_otp_req.dart' as _i5;
import 'package:lakuemas/features/otp/data/models/verify_otp_req.dart' as _i7;
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

/// A class which mocks [IForgotPasswordRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockIForgotPasswordRemoteDataSource extends _i1.Mock
    implements _i3.IForgotPasswordRemoteDataSource {
  MockIForgotPasswordRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.BaseResp<dynamic>> forgot(
    String? accessToken,
    String? refreshToken,
    String? newPassword,
    String? confirmPassword,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #forgot,
          [
            accessToken,
            refreshToken,
            newPassword,
            confirmPassword,
          ],
        ),
        returnValue:
            _i4.Future<_i2.BaseResp<dynamic>>.value(_FakeBaseResp_0<dynamic>(
          this,
          Invocation.method(
            #forgot,
            [
              accessToken,
              refreshToken,
              newPassword,
              confirmPassword,
            ],
          ),
        )),
      ) as _i4.Future<_i2.BaseResp<dynamic>>);

  @override
  _i4.Future<_i2.BaseResp<dynamic>> sendOtpForgot(_i5.SendOtpReq? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendOtpForgot,
          [request],
        ),
        returnValue:
            _i4.Future<_i2.BaseResp<dynamic>>.value(_FakeBaseResp_0<dynamic>(
          this,
          Invocation.method(
            #sendOtpForgot,
            [request],
          ),
        )),
      ) as _i4.Future<_i2.BaseResp<dynamic>>);

  @override
  _i4.Future<_i2.BaseResp<_i6.VerifyOtpForgotModel>> verifyOtpForgot(
          _i7.VerifyOtpReq? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #verifyOtpForgot,
          [request],
        ),
        returnValue: _i4.Future<_i2.BaseResp<_i6.VerifyOtpForgotModel>>.value(
            _FakeBaseResp_0<_i6.VerifyOtpForgotModel>(
          this,
          Invocation.method(
            #verifyOtpForgot,
            [request],
          ),
        )),
      ) as _i4.Future<_i2.BaseResp<_i6.VerifyOtpForgotModel>>);
}

/// A class which mocks [ITokenLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockITokenLocalDataSource extends _i1.Mock
    implements _i8.ITokenLocalDataSource {
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
