part of 'get_portofolio_bloc.dart';

sealed class GetPortofolioState extends Equatable {
  const GetPortofolioState();

  @override
  List<Object> get props => [];
}

final class GetPortofolioInitial extends GetPortofolioState {}

final class GetPortofolioLoadingState extends GetPortofolioState {}

final class GetPortofolioSuccessState extends GetPortofolioState {
  final PortofolioEntity portofolioEntity;

  const GetPortofolioSuccessState(this.portofolioEntity);

  @override
  List<Object> get props => [portofolioEntity];
}

final class GetPortofolioFailureState extends GetPortofolioState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetPortofolioFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
