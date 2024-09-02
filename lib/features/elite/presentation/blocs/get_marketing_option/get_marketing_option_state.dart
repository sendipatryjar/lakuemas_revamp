part of 'get_marketing_option_bloc.dart';

abstract class GetMarketingOptionState extends Equatable {
  const GetMarketingOptionState();

  @override
  List<Object> get props => [];
}

class GetMarketingOptionInitial extends GetMarketingOptionState {}

class GetMarketingOptionLoadingState extends GetMarketingOptionState {}

class GetMarketingSuccessState extends GetMarketingOptionState {
  final GetMarketingOptionEntity getMarketingOptionEntity;

  const GetMarketingSuccessState(this.getMarketingOptionEntity);

  @override
  List<Object> get props => [
        [getMarketingOptionEntity]
      ];
}

class GetMarketingFailureState extends GetMarketingOptionState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetMarketingFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
