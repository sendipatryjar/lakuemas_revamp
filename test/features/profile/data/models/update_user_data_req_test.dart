import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/data/models/update_user_data_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('update user data req', () {
    setUp(() {
      reqData = {
        'name': 'jhon doe',
        'gender': 'laki-laki',
        'place_of_birth': 'jakarta',
        'date_of_birth': '01-12-1999',
        'religion': 'islam',
        'marital_status': 'belum menikah',
        'income': 'income',
        'occupation': 'occupation',
        'purpose': 'purpose',
      };
    });
    test(
      'to json',
      () {
        const data = UpdateUserDataReq(
          name: 'jhon doe',
          gender: 'laki-laki',
          placeOfBirth: 'jakarta',
          dateOfBirth: '01-12-1999',
          religion: 'islam',
          maritalStatus: 'belum menikah',
          income: 'income',
          occupation: 'occupation',
          purpose: 'purpose',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
