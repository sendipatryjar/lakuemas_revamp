part of 'physical_pull_cubit.dart';

enum EnPhysicalPull { antam, lotus }

class PhysicalPullState extends Equatable {
  final EnPhysicalPull enPhysicalPull;
  final bool isError;
  final double? gBalance;
  final double? totGrammation;
  final List physicalPullReq;

  const PhysicalPullState({
    required this.enPhysicalPull,
    this.isError = false,
    this.gBalance,
    this.totGrammation,
    this.physicalPullReq = const [],
  });

  PhysicalPullState copyWith({
    EnPhysicalPull? enPhysicalPull,
    bool? isError,
    double? gBalance,
    double? totGrammation,
    List? physicalPullReq,
  }) =>
      PhysicalPullState(
        enPhysicalPull: enPhysicalPull ?? this.enPhysicalPull,
        isError: isError ?? this.isError,
        gBalance: gBalance ?? this.gBalance,
        totGrammation: totGrammation ?? this.totGrammation,
        physicalPullReq: physicalPullReq ?? this.physicalPullReq,
      );

  @override
  List<Object> get props => [
        [
          enPhysicalPull,
          isError,
          gBalance,
          totGrammation,
          physicalPullReq,
        ]
      ];
}
