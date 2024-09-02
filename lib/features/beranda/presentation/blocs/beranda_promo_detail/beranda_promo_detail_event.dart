part of 'beranda_promo_detail_bloc.dart';

sealed class BerandaPromoDetailEvent extends Equatable {
  const BerandaPromoDetailEvent();

  @override
  List<Object> get props => [];
}

class BerandaPromoDetailGetEvent extends BerandaPromoDetailEvent {
  final int? id;

  const BerandaPromoDetailGetEvent(this.id);

  @override
  List<Object> get props => [
        [id]
      ];
}
