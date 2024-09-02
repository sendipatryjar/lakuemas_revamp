import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/save_avatar/save_avatar_bloc.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<SaveAvatarBloc>(),
      child: BlocListener<SaveAvatarBloc, SaveAvatarState>(
        listener: (context, state) {
          if (state is SaveAvatarLoadingState) {
            EasyLoading.show();
          }
          if (state is SaveAvatarSuccessState) {
            context.read<HelperDataCubit>().resetDataProfile();
            EasyLoading.dismiss();
            context.goNamed(AppRoutes.profile);
          }
          if (state is SaveAvatarFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  _Content();

  WebViewController? _webviewController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: const Text(
              'Avatar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(AppRoutes.profile);
              },
            ),
          ),
          body: WebView(
            onWebViewCreated: (controller) async {
              _webviewController = controller;
              _webviewController
                  ?.loadFlutterAsset('assets/html/ready_player_me.html');
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                  name: 'WebView',
                  onMessageReceived: (s) {
                    appPrint('webviewAvatar: ${s.message}');
                    var resultJson = jsonDecode(s.message);
                    if (resultJson['eventName']?.toLowerCase() ==
                        'v1.avatar.exported') {
                      String? originUrl = resultJson['data']['url'];
                      if ((originUrl ?? '').isNotEmpty) {
                        String url = originUrl!.replaceRange(
                            (originUrl.length - 3), originUrl.length, 'png');
                        context
                            .read<SaveAvatarBloc>()
                            .add(SaveAvatarNowEvent(url));
                      }
                    }
                  }),
            },
          ),
        );
      },
    );
  }
}
