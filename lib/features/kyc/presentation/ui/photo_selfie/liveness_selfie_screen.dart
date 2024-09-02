import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/utils/app_utils.dart';
import '../../../../../cores/utils/image_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../blocs/liveness/liveness_bloc.dart';

class LivenessSelfieScreen extends StatelessWidget {
  const LivenessSelfieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<LivenessBloc>()..add(LivenessGenerateUrlEvent()),
      child: BlocListener<LivenessBloc, LivenessState>(
        listener: (context, state) {
          if (state is LivenessLoadingState) {
            EasyLoading.show();
          }
          if (state is LivenessSuccessState) {
            EasyLoading.dismiss();
          }
          if (state is LivenessFailureState) {
            context.pop();
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: const _Content(),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  // String livenessPrivyUrl =
  //     "https://stg-app.privypass.id/verification/active?application_id=a0211e22-16d8-4bed-b0b1-54139ad75a92&token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImV4YW1wbGUiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjE3MDMyMTg0NzIuNjI5OTQ3LCJpYXQiOjE3MDMxMzIxMzIuNjI5OTQ3LCJpc3MiOiJwcml2eS5pZCIsInN1YiI6ImQ3ZTM4OGUxLTBiZDUtNGNjYi1iYzViLTEwNTY3MmM1Y2M0OCIsImFkZGl0aW9uYWwiOnsiYWN0aXZhdGVkIjoiMDIxNDM2NDgtMjY5MS00NjUwLWI0MDctM2FmNmJiZDFiNDkxIiwic3ViamVjdCI6ImQ3ZTM4OGUxLTBiZDUtNGNjYi1iYzViLTEwNTY3MmM1Y2M0OCJ9fQ.YheA59ba0rMbTtKlXnT9jJ9Dw5VTbaW8mCCrct7hDy-zHm_WkPn0kg5U1u5JqUIHhmu2S7V2hAgio5Z7SqeTh9I9qNj5A03hqc7QnQcdhP3d2k1R_lOoTmi0e4RKaASOeHM05EW7sBri6-bOgqV4iiqa_1w6b2U91ILwG_ZizMcts5qOS_mnc-XIoE-nbzpVUptBPCnPFtovuB-BpzfCsxZLx-c0-RrE14-xLFZZFQgYFo6Q6LD2Nl5OdjJJSGGan1D79owt1AAzWYeo5HSn8S_F4uAqWgVEbauajFhs5H4Ti20HiX_diqp-xmmB0rX0ZG_vom-0Y5FVmTXkdI4FnA";

  InAppWebViewController? webviewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            options: PullToRefreshOptions(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webviewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webviewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webviewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          'Liveness',
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
      body: BlocBuilder<LivenessBloc, LivenessState>(
        builder: (context, state) {
          if (state is LivenessLoadingState) {
            return const Center(
              child: Text("loading.."),
            );
          }
          if (state is LivenessSuccessState) {
            return InAppWebView(
              initialFile: 'assets/html/liveness_privy.html',
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                  javaScriptEnabled: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                  allowsAirPlayForMediaPlayback: true,
                ),
              ),
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              onWebViewCreated: (InAppWebViewController controller) {
                controller.addJavaScriptHandler(
                  handlerName: 'sendUrlToJs',
                  callback: (args) {
                    return {'url': state.url};
                  },
                );

                controller.addJavaScriptHandler(
                    handlerName: 'myHandlerName',
                    callback: (args) {
                      appPrint("fl: $args");
                      if (args.isNotEmpty) {
                        var photoBase64 = args.first["face_1"];
                        EasyLoading.show();
                        MainImageUtils.base64ToFile(base64: photoBase64).then(
                          (value) {
                            EasyLoading.dismiss();
                            var xFile = XFile(value.path);
                            context.goNamed(
                              AppRoutes.accountVerificationSelfie,
                              extra: {
                                'xFile': xFile,
                                'backScreen':
                                    AppRoutes.accountVerificationSelfieGuide,
                                // 'aspectRatio': overlay.ratio,
                                // 'nik': value,
                              },
                            );
                          },
                        ).onError((error, stackTrace) {
                          EasyLoading.dismiss();
                          appPrintError("convert base64 to file error: $error");
                        });
                      }
                    });

                webviewController = controller;
              },
              onConsoleMessage: (controller, consoleMessage) {
                appPrint("flutter InAppWebView: ${consoleMessage.message}");
              },
              onLoadStart: (controller, url) {
                EasyLoading.show();
              },
              onLoadStop: (controller, url) {
                EasyLoading.dismiss();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
