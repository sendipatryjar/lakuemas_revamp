import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_notification_repository.dart';

class MakeReadAllNotifUc {
  final INotificationRepository repository;

  MakeReadAllNotifUc({required this.repository});

  Future<Either<AppFailure, bool>> call() => repository.makeReadAllNotif();
}
