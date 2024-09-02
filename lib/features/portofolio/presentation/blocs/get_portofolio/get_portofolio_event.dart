part of 'get_portofolio_bloc.dart';

sealed class GetPortofolioEvent extends Equatable {
  const GetPortofolioEvent();

  @override
  List<Object> get props => [];
}

class GetPortofolioLoadEvent extends GetPortofolioEvent {
  final HelperDataCubit helperDataCubit;

  const GetPortofolioLoadEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
