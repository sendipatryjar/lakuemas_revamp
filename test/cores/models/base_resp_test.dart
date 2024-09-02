import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';

void main() {
  test(
    'base resp success 200',
    () {
      Map<String, dynamic> resp = {
        "code": 200,
        "msg_key": "SUCCESS",
        "message": "string",
        "data": {
          "id": 0,
          "name": "string",
          "phone_number": "string",
          "email": "string",
          "created_at": "2019-08-24T14:15:22Z",
          "updated_at": "2019-08-24T14:15:22Z"
        }
      };

      final result = BaseResp.fromJson(resp, null);

      expect(result.code, equals(200));
      expect(result.msgKey, equals("SUCCESS"));
      expect(result.message, isA<String>());
      expect(result.errors, isNull);
    },
  );

  test(
    'base resp failed 400',
    () {
      Map<String, dynamic> resp = {
        "code": 400,
        "msg_key": "VALIDATION-ERROR",
        "message": "string",
        "errors": {"Email": "cant be empty"}
      };

      final result = BaseResp.fromJson(resp, null);

      expect(result.code, equals(400));
      expect(result.msgKey, equals("VALIDATION-ERROR"));
      expect(result.message, isA<String>());
      expect(result.errors, isMap);
    },
  );
}
