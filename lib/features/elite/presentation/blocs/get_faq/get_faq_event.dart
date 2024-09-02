part of 'get_faq_bloc.dart';

abstract class GetFaqEvent extends Equatable {
  const GetFaqEvent();

  @override
  List<Object> get props => [];
}

class GetFaqEvents extends GetFaqEvent {
  final String? sortBy;
  final String? orderBy;
  final int? isActive;
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetFaqEvents({
    this.sortBy,
    this.orderBy,
    this.isActive,
    required this.helperDataEliteCubit,
  });

  @override
  List<Object> get props => [
        [sortBy, orderBy, isActive, helperDataEliteCubit]
      ];
}
