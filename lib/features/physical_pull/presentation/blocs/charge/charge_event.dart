part of 'charge_bloc.dart';

abstract class ChargeEvent extends Equatable {
  const ChargeEvent();

  @override
  List<Object> get props => [];
}

class ChargePostEvent extends ChargeEvent {
  final List<Map<String, dynamic>>? listPhysicalPullReq;

  const ChargePostEvent(this.listPhysicalPullReq);

  @override
  List<Object> get props => [
        [listPhysicalPullReq]
      ];
}
