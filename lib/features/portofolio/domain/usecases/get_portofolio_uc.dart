import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/portofolio_entity.dart';
import '../repositories/i_portofolio_repository.dart';

class GetPortofolioUc {
  final IPortofolioRepository repository;

  GetPortofolioUc({required this.repository});

  Future<Either<AppFailure, PortofolioEntity>> call() =>
      repository.getPortofolio();
}
