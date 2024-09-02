part of 'beranda_promo_bloc.dart';

abstract class BerandaPromoEvent extends Equatable {
  final dynamic data;
  const BerandaPromoEvent(this.data);

  @override
  List<Object> get props => [data];
}

class BerandaPromoGetEvent extends BerandaPromoEvent {
  final HelperDataCubit helperDataCubit;

  const BerandaPromoGetEvent({required this.helperDataCubit})
      : super(helperDataCubit);
}
