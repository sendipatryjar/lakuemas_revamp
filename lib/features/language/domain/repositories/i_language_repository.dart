import '../entities/language_entity.dart';

abstract class ILanguageRepository {
  Future<bool> insLang(LanguageEntity? value);
  Future<LanguageEntity?> getLang();
}
