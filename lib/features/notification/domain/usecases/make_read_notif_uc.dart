import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_notification_repository.dart';

class MakeReadNotifUc {
  final INotificationRepository repository;

  MakeReadNotifUc({required this.repository});

  Future<Either<AppFailure, bool>> call(int? id) =>
      repository.makeReadNotif(id);
}
