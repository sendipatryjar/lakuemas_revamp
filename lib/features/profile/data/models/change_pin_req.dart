import 'package:equatable/equatable.dart';

class ChangePinReq extends Equatable {
  final String? oldPin;
  final String? newPin;
  final String? confirmPin;

  const ChangePinReq({this.oldPin, this.newPin, this.confirmPin});

  factory ChangePinReq.fromJson(Map<String, dynamic> json) {
    return ChangePinReq(
      oldPin: json['old_pin'],
      newPin: json['new_pin'],
      confirmPin: json['confirm_pin'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['old_pin'] = oldPin;
    data['new_pin'] = newPin;
    data['confirm_pin'] = confirmPin;
    return data;
  }

  @override
  List<Object?> get props => [oldPin, newPin, confirmPin];
}
