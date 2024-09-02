part of 'beranda_articles_bloc.dart';

abstract class BerandaArticlesEvent extends Equatable {
  final dynamic data;
  const BerandaArticlesEvent(this.data);

  @override
  List<Object> get props => [data];
}

class BerandaArticlesGetEvent extends BerandaArticlesEvent {
  final HelperDataCubit helperDataCubit;

  const BerandaArticlesGetEvent({required this.helperDataCubit})
      : super(helperDataCubit);
}
