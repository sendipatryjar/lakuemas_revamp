import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_dice_repository.dart';

class DiceGatchaUc {
  final IDiceRepository repository;

  DiceGatchaUc({required this.repository});

  Future<Either<AppFailure, bool?>> call({int? qty}) => repository.gatcha(qty: qty);
}
