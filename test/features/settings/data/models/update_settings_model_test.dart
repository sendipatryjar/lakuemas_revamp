import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/settings/data/models/update_settings_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('update settings req', () {
    setUp(() {
      reqData = {
        'with_price': true,
        'with_promo': true,
      };
    });

    test(
      'update settings to json',
      () {
        var data = const UpdateSettingsReq(
          withPrice: true,
          withPromo: true,
        );

        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
