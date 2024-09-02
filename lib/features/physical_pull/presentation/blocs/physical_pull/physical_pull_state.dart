part of 'physical_pull_bloc.dart';

abstract class PhysicalPullState extends Equatable {
  const PhysicalPullState();
  
  @override
  List<Object> get props => [];
}

class PhysicalPullInitial extends PhysicalPullState {}
