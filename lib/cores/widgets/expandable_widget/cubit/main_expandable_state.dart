part of 'main_expandable_cubit.dart';

class MainExpandableState extends Equatable {
  final bool isExpanded;
  const MainExpandableState({this.isExpanded = false});

  @override
  List<Object> get props => [isExpanded];
}
