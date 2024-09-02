import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class LakusaveCancelUc {
  final ILakusaveRepository repository;

  LakusaveCancelUc({required this.repository});

  Future<Either<AppFailure, bool>> call({String? transactionCode}) =>
      repository.cancel(transactionCode: transactionCode);
}
