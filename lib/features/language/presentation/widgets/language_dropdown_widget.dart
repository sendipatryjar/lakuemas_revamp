import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/language_entity.dart';
import '../cubit/languages_cubit.dart';

class LanguageDropdownWidget extends StatelessWidget {
  final Color? iconColor;
  const LanguageDropdownWidget({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagesCubit, LanguagesStateData>(
      builder: (context, state) {
        return DropdownButton<LanguageEntity>(
          underline: const SizedBox(),
          isExpanded: false,
          value: state.selectedLanguage,
          onChanged: context.read<LanguagesCubit>().changeLang,
          iconEnabledColor: iconColor,
          items: state.languages
              .map<DropdownMenuItem<LanguageEntity>>(
                (e) => DropdownMenuItem<LanguageEntity>(
                  value: e,
                  child: Text(
                    e.flag ?? '-',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
