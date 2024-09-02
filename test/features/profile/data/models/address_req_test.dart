import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/data/models/address_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('address req', () {
    setUp(() {
      reqData = {
        "limit": 10,
        "page": 1,
        "province_id": 1,
        "city_id": 1,
        "sort_by": "name",
        "order_by": "name",
      };
    });
    test(
      'to json',
      () {
        const data = AddressReq(
          cityId: 1,
          provinceId: 1,
          limit: 10,
          page: 1,
          orderBy: 'name',
          sortBy: 'name',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
