import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_close_account_repository.dart';

class CloseAccountSubmitUc {
  final ICloseAccountRepository repository;

  CloseAccountSubmitUc({required this.repository});

  Future<Either<AppFailure, bool>> call(String reason) {
    return repository.submit(reason);
  }
}
