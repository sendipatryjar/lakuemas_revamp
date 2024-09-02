// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../cubit/languages_cubit.dart';

// class LanguageSwitchWidget extends StatelessWidget {
//   final double height;
//   final double width;
//   final double circleSize;
//   const LanguageSwitchWidget(
//       {super.key, this.height = 32, this.width = 64, this.circleSize = 16});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LanguagesCubit, LanguagesStateData>(
//       builder: (context, state) {
//         bool helperValue =
//             state.selectedLanguage?.code == state.languages[0].code;
//         return CustomSwitchWidget(
//           height: height,
//           width: width,
//           circleSize: circleSize,
//           bgImage: DecorationImage(
//             fit: BoxFit.cover,
//             image: helperValue
//                 ? const AssetImage(
//                     imFlagEn,
//                   )
//                 : const AssetImage(
//                     imFlagId,
//                   ),
//           ),
//           value: helperValue,
//           onChanged: () {
//             final helper = !helperValue;
//             if (helper) {
//               context.read<LanguagesCubit>().changeLang(state.languages[0]);
//               context.read<SideMenuCubit>().init();
//             } else {
//               context.read<LanguagesCubit>().changeLang(state.languages[1]);
//               context.read<SideMenuCubit>().init();
//             }
//           },
//         );
//       },
//     );
//   }
// }
