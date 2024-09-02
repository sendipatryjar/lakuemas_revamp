import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class LakusaveUpdateExtendUc {
  final ILakusaveRepository repository;

  LakusaveUpdateExtendUc({required this.repository});

  Future<Either<AppFailure, bool>> call({
    int? extendId,
    String? accountNumber,
  }) =>
      repository.updateExtend(
        extendId: extendId,
        accountNumber: accountNumber,
      );
}
