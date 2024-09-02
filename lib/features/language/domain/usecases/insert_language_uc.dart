import '../entities/language_entity.dart';
import '../repositories/i_language_repository.dart';

class InsertLanguageUc {
  final ILanguageRepository repository;

  InsertLanguageUc({required this.repository});

  Future<bool?> call(LanguageEntity? value) {
    return repository.insLang(value);
  }
}
