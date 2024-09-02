// Mocks generated by Mockito 5.4.4 from annotations
// in lakuemas/test/features/otp/data/data_sources/otp_remote_data_source_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:typed_data' as _i5;

import 'package:dio/src/adapter.dart' as _i2;
import 'package:dio/src/options.dart' as _i4;
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

class _FakeResponseBody_0 extends _i1.SmartFake implements _i2.ResponseBody {
  _FakeResponseBody_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HttpClientAdapter].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClientAdapter extends _i1.Mock implements _i2.HttpClientAdapter {
  MockHttpClientAdapter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.ResponseBody> fetch(
    _i4.RequestOptions? options,
    _i3.Stream<_i5.Uint8List>? requestStream,
    _i3.Future<void>? cancelFuture,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetch,
          [
            options,
            requestStream,
            cancelFuture,
          ],
        ),
        returnValue: _i3.Future<_i2.ResponseBody>.value(_FakeResponseBody_0(
          this,
          Invocation.method(
            #fetch,
            [
              options,
              requestStream,
              cancelFuture,
            ],
          ),
        )),
      ) as _i3.Future<_i2.ResponseBody>);

  @override
  void close({bool? force = false}) => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
          {#force: force},
        ),
        returnValueForMissingStub: null,
      );
}
