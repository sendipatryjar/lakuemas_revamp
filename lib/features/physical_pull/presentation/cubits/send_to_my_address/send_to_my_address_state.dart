part of 'send_to_my_address_cubit.dart';

class SendToMyAddressState extends Equatable {
  final int? index;

  const SendToMyAddressState({this.index});

  SendToMyAddressState copyWith({
    int? index,
  }) =>
      SendToMyAddressState(
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [index];
}
