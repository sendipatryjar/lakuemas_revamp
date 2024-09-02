import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../cores/constants/app_color.dart';
import '../cores/depedencies_injection/depedency_injection.dart';
import '../cores/routes/app_navigation.dart';
import '../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import 'language/presentation/cubit/languages_cubit.dart';
import 'support/presentation/blocs/support_contact/support_contact_bloc.dart';

class App extends StatelessWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    var goRouter = AppNavigation.router(initialRoute);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<LanguagesCubit>()..init(),
          ),
          BlocProvider(
            create: (context) =>
                sl<HelperDataCubit>()..updateShowPopupVerification(true),
          ),
          BlocProvider(
            create: (context) => sl<HelperDataEliteCubit>(),
          ),
          BlocProvider(
            create: (context) =>
                sl<SupportContactBloc>()..add(SupportContactGetEvent()),
          ),
        ],
        child: BlocBuilder<LanguagesCubit, LanguagesStateData>(
          builder: (context, state) {
            return _buildRunnableApp(
              // isWeb: kIsWeb,
              isWeb: false,
              webAppWidth: 480,
              app: MaterialApp.router(
                title: 'Lakuemas',
                theme: ThemeData(
                  primaryColor: Colors.yellow[600],
                  // scaffoldBackgroundColor: clrBackgroundBlack,
                  fontFamily: 'Poppins',
                  appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                      color: clrWhite,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),
                // darkTheme: ThemeData.dark(),
                // themeMode: ThemeMode.system,
                locale: state.selectedLocale,
                supportedLocales: state.locales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: EasyLoading.init(),
                routerDelegate: goRouter.routerDelegate,
                routeInformationParser: goRouter.routeInformationParser,
                routeInformationProvider: goRouter.routeInformationProvider,
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Container(
    color: clrGreyE5e,
    child: Center(
      child: ClipRect(
        child: SizedBox(
          width: webAppWidth,
          child: app,
        ),
      ),
    ),
  );
}
