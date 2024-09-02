import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/routes/go_router_observer.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/laku_trade_qr/laku_trade_qr_bloc.dart';

class LakuTradeScreen extends StatelessWidget {
  const LakuTradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<LakuTradeQrBloc>(),
      child: _Content(key: key, t: t),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    super.key,
    required this.t,
  });

  final AppLocalizations t;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    onLakuTradeDetailPoped = () {
      controller?.resumeCamera();
    };
  }

  @override
  void dispose() {
    controller?.dispose();
    onLakuTradeDetailPoped = () {};
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      appPrint('reassemble: android');
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      appPrint('reassemble: ios');
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocListener<LakuTradeQrBloc, LakuTradeQrState>(
      listener: (context, state) {
        if (state is LakuTradeQrLoadingState) {
          EasyLoading.show();
        }
        if (state is LakuTradeQrSuccessState) {
          EasyLoading.dismiss();
          controller?.pauseCamera();
          context.goNamed(
            AppRoutes.lakuTradeDetail,
            extra: {
              'isElite': context.read<EliteCubit>().state.toString(),
              'lakuTradeQrDataEntity': state.data,
            },
          );
        }
        if (state is LakuTradeQrFailureState) {
          EasyLoading.showError(
            errorMessage(state.appFailure) ?? t.lblSomethingWrong,
            dismissOnTap: true,
          ).then((value) {
            controller?.resumeCamera();
          }).catchError((error) {
            controller?.resumeCamera();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrBlack040,
          centerTitle: true,
          title: Text(
            'Laku ${t.lblTrade}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: MainBackButton(
            onPressed: () {
              context.goNamed(AppRoutes.beranda);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.expand,
          children: [
            _buildQrView(context),
            Positioned.fill(
              top: 300,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Sejajarkan kode QR di dalam bingkai',
                    style: TextStyle(
                      color: clrWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        overlayColor: clr000000.withOpacity(0.85),
        borderColor: clrYellow,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 5,
        cutOutSize: 240.0,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    // context.read<LakuTradeQrBloc>().add(const LakuTradeQrGetDataEvent(
    //     'eyJpdiI6Im9LWGxvb1N4Z0dxdnJoMzZ5RjBhS0E9PSIsIm1hYyI6IjQyNzA4MjEwYjUyNGU4NmQ0NzdmN2MyMGFmNmVmZWM5ZTAwZGUxOGIzYWRmOTQxOWY1MjI3ZDU2MDY4OWZkNWQiLCJ2YWx1ZSI6Im9LWGxvb1N4Z0dxdnJoMzZ5RjBhS05Eak9wemVVMlZ6S1NIdjdXWmZINDIya2tWV094dnliaTFsWSs5YVRmREcifQ=='));
    controller.scannedDataStream.listen((scanData) {
      appPrint('qr data: ${scanData.code.toString()}');
      if ((scanData.code ?? '').isNotEmpty) {
        context
            .read<LakuTradeQrBloc>()
            .add(LakuTradeQrGetDataEvent(scanData.code));
        controller.pauseCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      Permission.camera.request().then((status) {
        if (status.isPermanentlyDenied) {
          DialogUtils.universal(
            context: context,
            barrierDismissible: true,
            icon: Image.asset(icWarningYellow),
            firstDesc: 'Perizinan Kamera',
            secondDesc:
                'Mohon untuk aktifkan perizinan kamera pada menu Settings di ponsel anda',
            btnText: 'Buka Settings',
            btnConfirm: () => openAppSettings(),
          );
        }
      });
    }
  }
}
