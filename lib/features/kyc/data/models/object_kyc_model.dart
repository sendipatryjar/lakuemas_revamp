import '../../domain/entities/object_kyc_entity.dart';

class ObjectKycModel extends ObjectKycEntity {
  ObjectKycModel({
    int? bankId,
    String? number,
    String? name,
    String? pob,
    String? dob,
    int? status,
    String? imageUrl,
    String? reason,
  }) : super(
          bankId: bankId,
          number: number,
          name: name,
          pob: pob,
          dob: dob,
          status: status,
          imageUrl: imageUrl,
          reason: reason,
        );

  ObjectKycModel.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id'];
    number = json['number'];
    name = json['name'];
    pob = json['pob'];
    dob = json['dob'];
    status = json['status'];
    imageUrl = json['image_url'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_id'] = bankId;
    data['number'] = number;
    data['name'] = name;
    data['pob'] = pob;
    data['dob'] = dob;
    data['status'] = status;
    data['image_url'] = imageUrl;
    data['reason'] = reason;
    return data;
  }
}
