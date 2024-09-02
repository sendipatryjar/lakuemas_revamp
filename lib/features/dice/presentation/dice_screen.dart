import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/configs/environment.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import 'blocs/bloc/dice_gatcha_bloc.dart';

class DiceScreen extends StatelessWidget {
  const DiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DiceGatchaBloc>(),
      child: _Content(key: key),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({super.key});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  UnityWidgetController? _unityWidgetController;

  String? balanceStr = "";
  String username = "Tester";
  double? minimum1Gacha;
  Map<String, dynamic> sample = {};
  int _reHitCount = 0;

  _exitDialog() {
    DialogUtils.confirm(
      context: context,
      barrierDismissible: true,
      firstDesc: 'Apakah kamu yakin ingin keluar dari halaman gatcha?',
      btnText: 'Ya',
      btnTextLater: 'Tidak',
      btnConfirm: () async {
        context.goNamed(AppRoutes.beranda);

        context.read<HelperDataCubit>().exitButtonOnUnity(false);
        await _unityWidgetController?.unload();
      },
      btnLater: () {
        context.pop();
      },
    );
  }

  _showExitButton(String? scene) {
    if (scene?.toLowerCase() == "shop") {
      context.read<HelperDataCubit>().exitButtonOnUnity(false);
    } else {
      if (context.read<HelperDataCubit>().state.isFirstTimeRunUnity == false) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          context.read<HelperDataCubit>().exitButtonOnUnity(true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    swipeBackDice = _exitDialog;
    if (context.read<HelperDataCubit>().state.isFirstTimeRunUnity) {
      EasyLoading.show();
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    username =
        context.read<HelperDataCubit>().state.userDataEntity?.name ?? "-";
    balanceStr = context
            .read<HelperDataCubit>()
            .state
            .balances
            .asMap()[0]
            ?.gramationBalance ??
        "-";
    minimum1Gacha = double.tryParse(
        context.read<HelperDataCubit>().state.priceSettings?.gatchaPrice ?? "");
    return BlocListener<DiceGatchaBloc, DiceGatchaState>(
      listener: (context, state) {
        if (state is DiceGatchaLoadingState) {
          appPrint("[mobilefl] LOADING potong saldo ke server utama");
        }
        if (state is DiceGatchaSuccessState) {
          _reHitCount = 0;
          appPrint("[mobilefl] BERHASIL potong saldo ke server utama");
          context.read<HelperDataCubit>().resetDataAfterTrx();
        }
        if (state is DiceGatchaFailureState) {
          appPrintError("[mobilefl] GAGAL potong saldo ke server utama");
          if (state.appFailure is ServerFailure) {
            _reHitCount = _reHitCount + 1;
            context
                .read<DiceGatchaBloc>()
                .add(DiceGatchaDoNowEvent(reHitCount: _reHitCount, qty: 1));
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (val) {
          _exitDialog();
        },
        child: Scaffold(
          backgroundColor: clrBackgroundBlack,
          body: Stack(
            children: [
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                useAndroidViewSurface: false,
                runImmediately: true,
                fullscreen: false,
                unloadOnDispose: true,
              ),
              BlocBuilder<HelperDataCubit, HelperDataState>(
                buildWhen: (previous, current) =>
                    previous.isShowExitButtonOnDice !=
                    current.isShowExitButtonOnDice,
                builder: (context, state) {
                  return Visibility(
                    visible: state.isShowExitButtonOnDice,
                    child: Positioned(
                      left: 0,
                      right: 0,
                      bottom: 80,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            _exitDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: clrYellow),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Keluar",
                              style: TextStyle(color: clrYellow),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(UnityWidgetController? controller) async {
    controller?.resume();
    _unityWidgetController = controller;

    _showExitButton(context.read<HelperDataCubit>().state.unityDiceScene);
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    appPrint('[mobilefl] Received scene loaded from unity: ${sceneInfo?.name}');
    appPrint(
        '[mobilefl] Received scene loaded from unity buildIndex: ${sceneInfo?.buildIndex}');
    _showExitButton(sceneInfo?.name);
    context.read<HelperDataCubit>().unityDiceScene(sceneInfo?.name);
    context.read<HelperDataCubit>().firstTimeRunUnity(false);
  }

  void onUnityMessage(message) {
    if (context.read<HelperDataCubit>().state.isFirstTimeRunUnity) {
      context.read<HelperDataCubit>().firstTimeRunUnity(false);
      context.goNamed(AppRoutes.beranda);
      Future.delayed(const Duration(milliseconds: 30)).then((value) {
        context.goNamed(AppRoutes.gachaPon);
      });
    }
    appPrint('[mobilefl] Received message from unity: ${message.toString()}');
    if (message.toString() == "sendData") {
      sample = {
        "user": username,
        "gold": balanceStr,
        "url": Environment.baseUrlDice(),
        "DID": "000",
      };
      _setGoldandUsername(sample);
    }
    if (message.toString() == "RequestPrice") {
      _sendGatchaPrice(minimum1Gacha?.toStringAsFixed(4));
    }
    if (message.toString() == "RequestRollBox1") {
      double? goldBalance = double.tryParse(balanceStr ?? "");
      _checkbalancegacha(goldBalance);
    }
    if (message.toString() == "dadubaru1") {
      double? goldBalance = double.tryParse(balanceStr ?? "");
      if (goldBalance == null || minimum1Gacha == null) return;
      double newGoldBalance = goldBalance - minimum1Gacha!;
      balanceStr = newGoldBalance.toGold4Dec();
      context
          .read<DiceGatchaBloc>()
          .add(DiceGatchaDoNowEvent(reHitCount: _reHitCount, qty: 1));
    }
    // if (message.toString() == "RequestRollBox10") {
    //   appPrint('Received message from unity: ${message.toString()}');
    //   _checkbalancegacha(10);
    // }
    // if (message.toString() == "sendBackGold1") {
    //   // balance = balance + 0.1;
    //   sample = {"user": username, "gold": balance.toString()};
    //   _setGoldandUsername(sample);
    // }
    // if (message.toString() == "dadubaru10") {
    //   balance = balance - minimum10Gacha;
    // }
  }

  void _setGoldandUsername(Map<String, dynamic> values) {
    appPrint('[mobilefl] Sending game data to unity: $values');
    _unityWidgetController?.postJsonMessage(
        'FlutterManager', 'SetDataFromJson', values);
  }

  void _checkbalancegacha(double? goldBalance) {
    Map<String, dynamic> data = {
      "nominal": 1,
      "result": "!ok",
      'minimum': minimum1Gacha
    };
    if (goldBalance != null &&
        minimum1Gacha != null &&
        goldBalance >= minimum1Gacha!) {
      data = {"nominal": 1, "result": "ok", 'minimum': minimum1Gacha};
    }
    _unityWidgetController?.postJsonMessage('FlutterManager', 'Pull', data);
  }

  void _sendGatchaPrice(String? price) {
    _unityWidgetController?.postMessage('FlutterManager', 'LoadHarga', price);
  }

  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // Map<String, dynamic> _deviceData = <String, dynamic>{};

  // Future<void> initPlatformState() async {
  //   var deviceData = <String, dynamic>{};

  //   try {
  //     if (Platform.isAndroid) {
  //       deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //       var did = md5.convert(utf8.encode(deviceData['id']));
  //       print('Android ID $did');
  //       deviceId = did.toString();
  //     }
  //     if (Platform.isIOS) {
  //       deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  //       var did = md5.convert(utf8.encode(deviceData['identifierForVendor']));
  //       print('IOS ID $did');
  //       deviceId = did.toString();
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _deviceData = deviceData;
  //   });
  // }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }
}
