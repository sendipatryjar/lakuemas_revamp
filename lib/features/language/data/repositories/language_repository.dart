import '../../domain/entities/language_entity.dart';
import '../../domain/repositories/i_language_repository.dart';
import '../data_sources/intefaces/i_language_local_data_source.dart';
import '../models/language_model.dart';

class LanguageRepository implements ILanguageRepository {
  final ILanguageLocalDataSource localDataSource;

  LanguageRepository({required this.localDataSource});

  @override
  Future<bool> insLang(LanguageEntity? value) async {
    final req = LanguageModel(
      code: value?.code,
      flag: value?.flag,
      name: value?.name,
    );
    final result = await localDataSource.insLang(req);
    return result;
  }

  @override
  Future<LanguageEntity?> getLang() async {
    final result = await localDataSource.getLang();
    return result;
  }
}
