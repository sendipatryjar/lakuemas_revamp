part of 'support_faq_bloc.dart';

sealed class SupportFaqEvent extends Equatable {
  const SupportFaqEvent();

  @override
  List<Object> get props => [];
}

class SupportFaqGetEvent extends SupportFaqEvent {
  final String? keyword;

  const SupportFaqGetEvent(this.keyword);

  @override
  List<Object> get props => [
        [keyword]
      ];
}
