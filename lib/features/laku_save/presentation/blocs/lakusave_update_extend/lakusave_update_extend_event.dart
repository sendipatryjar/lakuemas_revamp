part of 'lakusave_update_extend_bloc.dart';

abstract class LakusaveUpdateExtendEvent extends Equatable {
  const LakusaveUpdateExtendEvent();

  @override
  List<Object> get props => [];
}

class LakusaveUpdateExtendNowEvent extends LakusaveUpdateExtendEvent {
  final int? extendId;
  final String? accountNumber;

  const LakusaveUpdateExtendNowEvent({this.extendId, this.accountNumber});

  @override
  List<Object> get props => [
        [extendId, accountNumber]
      ];
}
