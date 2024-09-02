part of 'get_banks_bloc.dart';

abstract class GetBanksEvent extends Equatable {
  const GetBanksEvent();

  @override
  List<Object> get props => [];
}

class BankAccountGetEvent extends GetBanksEvent {
  final int? limit;
  final int? page;
  final String? sortBy;

  const BankAccountGetEvent({this.limit, this.page, this.sortBy});

  @override
  List<Object> get props => [
        [limit, page, sortBy]
      ];
}
