import '../entities/language_entity.dart';
import '../repositories/i_language_repository.dart';

class GetLanguageUc {
  final ILanguageRepository repository;

  GetLanguageUc({required this.repository});

  Future<LanguageEntity?> call() {
    return repository.getLang();
  }
}
