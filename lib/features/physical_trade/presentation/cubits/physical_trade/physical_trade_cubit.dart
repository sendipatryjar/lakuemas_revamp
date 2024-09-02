import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'physical_trade_state.dart';

class PhysicalTradeCubit extends Cubit<PhysicalTradeState> {
  PhysicalTradeCubit() : super(PhysicalTradeInitial());
}
