import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/lakusave_about/lakusave_about_bloc.dart';

class AboutLakuSaveScreen extends StatelessWidget {
  const AboutLakuSaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) =>
          sl<LakusaveAboutBloc>()..add(LakusaveAboutGetEvent()),
      child: _Content(t: t),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    // final WebViewController webviewCtr = WebViewController();
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblLakuSave,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: BlocBuilder<LakusaveAboutBloc, LakusaveAboutState>(
            builder: (context, state) {
              String htmlStr = '';
              if (state is LakusaveAboutLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LakusaveAboutSuccessState) {
                htmlStr = state.data ?? '';
                // webviewCtr.loadHtmlString(htmlStr);
                // webviewCtr.setJavaScriptMode(JavaScriptMode.unrestricted);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  // child: WebViewWidget(
                  //   controller: webviewCtr,
                  // ),
                  child: WebView(
                    gestureNavigationEnabled: true,
                    onWebViewCreated: (controller) {
                      controller.loadHtmlString(htmlStr);
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
