import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/menu_entity.dart';
import '../repositories/i_beranda_repository.dart';

class GetMenusUc {
  final IBerandaRepository repository;

  GetMenusUc({required this.repository});

  Future<Either<AppFailure, List<MenuEntity>>> call() => repository.getMenus();
}
