part of 'fab_cubit.dart';

class FabState extends Equatable {
  final bool? isGachaPonShowed;
  const FabState({this.isGachaPonShowed = true});

  @override
  List<Object> get props => [
        [isGachaPonShowed]
      ];

  FabState copyWith({
    bool? isGachaPonShowed,
  }) =>
      FabState(
        isGachaPonShowed: isGachaPonShowed ?? this.isGachaPonShowed,
      );
}
