import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../cores/configs/environment.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';

class ChatUsScreen extends StatelessWidget {
  const ChatUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _Content(
      t: t,
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              'Chat ${t.lblUs}',
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
          body: WebView(
            onWebViewCreated: (controller) {
              controller.loadRequest(
                WebViewRequest(
                  uri: Uri.parse(
                      '${Environment.baseUrlMember()}/api/v1/help/chat'),
                  // uri: Uri.http(
                  //   Environment.baseUrlMember().split('//')[1],
                  //   '/api/v1/help/chat',
                  // ),
                  method: WebViewRequestMethod.get,
                ),
              );
            },
            javascriptMode: JavascriptMode.unrestricted,
          ),
        );
      },
    );
  }
}
