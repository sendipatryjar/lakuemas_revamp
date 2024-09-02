import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/lakusave_extend_entity.dart';

class LakusaveUpdateExtendCubit extends Cubit<LakusaveExtendEntity?> {
  LakusaveUpdateExtendCubit() : super(null);

  void change(LakusaveExtendEntity? value) => emit(value);
}
