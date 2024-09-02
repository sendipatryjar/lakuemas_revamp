import '../../models/language_model.dart';

abstract class ILanguageLocalDataSource {
  Future<bool> insLang(LanguageModel? value);
  Future<LanguageModel?> getLang();
}
