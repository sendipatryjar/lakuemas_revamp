import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/privy_const.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/login/login_bloc.dart';

class LoginPrivyScreen extends StatelessWidget {
  const LoginPrivyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBlack101,
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
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
      body: WebView(
        initialUrl: PrivyConst.authUri,
        onWebViewCreated: (controller) async {
          controller.clearCache();
          CookieManager().clearCookies();
        },
        navigationDelegate: (navigation) async {
          appPrint('[navigationDelegate] url: ${navigation.url}');
          if (navigation.url.contains('code=')) {
            Uri uri = Uri.parse(navigation.url);
            var code = uri.queryParameters['code'];
            appPrint('[navigationDelegate] code: $code');
            context.read<LoginBloc>().add(LoginPrivyPressed(context, code));
            context.pop();
            return NavigationDecision.prevent;
          }
          if (navigation.url.contains('play.google.com/store/apps/details')) {
            AppUtils.openStore(navigation.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
