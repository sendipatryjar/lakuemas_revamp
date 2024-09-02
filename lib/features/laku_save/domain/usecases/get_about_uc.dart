import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class GetAboutUc {
  final ILakusaveRepository repository;

  GetAboutUc({required this.repository});

  Future<Either<AppFailure, String?>> call() => repository.getAbout();
}
