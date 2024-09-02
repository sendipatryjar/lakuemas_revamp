part of 'get_marketing_option_bloc.dart';

abstract class GetMarketingOptionEvent extends Equatable {
  const GetMarketingOptionEvent();

  @override
  List<Object> get props => [];
}

class GetMarketingOptionEvents extends GetMarketingOptionEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetMarketingOptionEvents({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}
