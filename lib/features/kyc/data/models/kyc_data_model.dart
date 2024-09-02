import '../../domain/entities/kyc_entity.dart';
import 'object_kyc_model.dart';

// ignore: must_be_immutable
class KycDataModel extends KycEntity {
  KycDataModel({
    Map<String, ObjectKycModel?>? objectKyc,
  }) : super(
          objectKyc: objectKyc,
        );

  KycDataModel.fromJson(Map<String, dynamic> json) {
    objectKyc = {
      if (json['ktp'] != null) ...{'ktp': ObjectKycModel.fromJson(json['ktp'])},
      if (json['npwp'] != null) ...{
        'npwp': ObjectKycModel.fromJson(json['npwp'])
      },
      if (json['selfie'] != null) ...{
        'selfie': ObjectKycModel.fromJson(json['selfie'])
      },
      if (json['account_number'] != null) ...{
        'account_number': ObjectKycModel.fromJson(json['account_number'])
      }
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>? data = <String, dynamic>{};
    data = objectKyc?.map(
      (key, value) => MapEntry(
        key,
        ObjectKycModel(
          bankId: value?.bankId,
          status: value?.status,
          number: value?.number,
          name: value?.name,
          pob: value?.pob,
          dob: value?.dob,
          imageUrl: value?.imageUrl,
          reason: value?.reason,
        ).toJson(),
      ),
    );
    return data ?? {};
  }
}
