import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/data/models/get_transactions_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('get transactions req', () {
    setUp(() {
      reqData = {
        "limit": 10,
        'page': 1,
        'sort_by': 'DESC',
        'order_by': 'created_at',
        'status': 1,
        'type': 'type',
      };
    });

    test(
      'to json',
      () {
        final data = GetTransactionsReq(
          limit: 10,
          page: 1,
          sortBy: 'DESC',
          orderBy: 'created_at',
          status: 1,
          type: 'type',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
