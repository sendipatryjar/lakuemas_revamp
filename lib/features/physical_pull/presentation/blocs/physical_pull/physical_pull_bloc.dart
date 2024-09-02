import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'physical_pull_event.dart';
part 'physical_pull_state.dart';

class PhysicalPullBloc extends Bloc<PhysicalPullEvent, PhysicalPullState> {
  PhysicalPullBloc() : super(PhysicalPullInitial()) {
    on<PhysicalPullEvent>((event, emit) {});
  }
}
