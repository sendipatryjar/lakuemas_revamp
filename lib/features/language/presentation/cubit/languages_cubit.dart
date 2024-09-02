import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../language/domain/entities/language_entity.dart';
import '../../domain/usecases/get_language_uc.dart';
import '../../domain/usecases/insert_language_uc.dart';

part 'languages_state.dart';

class LanguagesCubit extends Cubit<LanguagesStateData> {
  final InsertLanguageUc insertLanguageUc;
  final GetLanguageUc getLanguageUc;

  LanguagesCubit({
    required this.insertLanguageUc,
    required this.getLanguageUc,
  }) : super(const LanguagesStateData(
          locales: [
            Locale('en'),
            Locale('id'),
          ],
          languages: [
            LanguageEntity(
              code: 'en',
              flag: '🇺🇸',
              // flagAsset: imFlagEn,
              name: 'United States',
            ),
            LanguageEntity(
              code: 'id',
              flag: '🇮🇩',
              // flagAsset: imFlagId,
              name: 'Indonesia',
            ),
          ],
        ));

  void init() async {
    final savedLanguage = await getLanguageUc();
    if (savedLanguage != null) {
      var lang = LanguageEntity(
        code: savedLanguage.code,
        flag: savedLanguage.flag,
        flagAsset: savedLanguage.flagAsset,
        name: savedLanguage.name,
      );
      changeLang(lang);
      return;
    }
    const defaultLang = LanguageEntity(
      code: 'id',
      flag: '🇮🇩',
      // flagAsset: imFlagId,
      name: 'Indonesia',
    );
    await insertLanguageUc(defaultLang);
    changeLang(defaultLang);
  }

  void changeLang(LanguageEntity? value) async {
    await insertLanguageUc(value);
    Locale? locale =
        value?.code != null ? Locale(value!.code!) : state.selectedLocale;
    emit(state.copyWith(
      selectedLanguage: value,
      selectedLocale: locale,
    ));
  }
}
