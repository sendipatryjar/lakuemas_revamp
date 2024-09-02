part of 'languages_cubit.dart';

class LanguagesStateData extends Equatable {
  final List<Locale> locales;
  final List<LanguageEntity> languages;
  final Locale? selectedLocale;
  final LanguageEntity? selectedLanguage;

  const LanguagesStateData({
    this.locales = const [],
    this.languages = const [],
    this.selectedLocale,
    this.selectedLanguage,
  });

  LanguagesStateData copyWith({
    List<Locale>? locales,
    List<LanguageEntity>? languages,
    Locale? selectedLocale,
    LanguageEntity? selectedLanguage,
  }) =>
      LanguagesStateData(
        locales: locales ?? this.locales,
        languages: languages ?? this.languages,
        selectedLocale: selectedLocale ?? this.selectedLocale,
        selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      );

  @override
  List<Object> get props => [
        [locales, languages, selectedLocale, selectedLanguage]
      ];
}
