// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../cores/utils/permissions_utils.dart';
import '../../../../cores/utils/share_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../beranda/presentation/blocs/balance/balance_bloc.dart';
import '../cubits/qr_transfer/qr_transfer_cubit.dart';
import 'qr_code_content.dart';
import 'tab_widget.dart';

class QRTransferTab extends StatefulWidget {
  final bool isElite;
  const QRTransferTab({super.key, this.isElite = false});

  @override
  State<QRTransferTab> createState() => _QRTransferTabState();
}

class _QRTransferTabState extends State<QRTransferTab>
    with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late Animation<double> verticalPosition;
  late AnimationController animationController;

  Barcode? result;
  String? decodedQR;
  QRViewController? controller;
  ScreenshotController screenshotController = ScreenshotController();
  bool isPaused = false;

  _requestCamera() {
    return Permission.camera.request().then((value) {
      appPrint("camera permission: $value");
      context.read<QrTransferCubit>().changeCameraPermission(value);
    }).onError((error, stackTrace) {
      context
          .read<QrTransferCubit>()
          .changeCameraPermission(PermissionStatus.permanentlyDenied);
    }).catchError((e) {
      context
          .read<QrTransferCubit>()
          .changeCameraPermission(PermissionStatus.permanentlyDenied);
    });
  }

  @override
  void initState() {
    super.initState();
    appPrint("QRTransferTab initState called");
    WidgetsBinding.instance.addObserver(this);
    _requestCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      appPrint("QRTransferTab AppLifecycleState.resumed called");
      appPrint("isPaused: $isPaused");
      if (isPaused) {
        _requestCamera();
      }
      isPaused = false;
    }
    if (state == AppLifecycleState.paused) {
      appPrint("QRTransferTab AppLifecycleState.paused called");
      isPaused = true;
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    appPrint("QRTransferTab reassemble called");
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    appPrint("QRTransferTab dispose called");
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Future<String?> parseQRCode(String imagePath) async {
      try {
        return await Scan.parse(imagePath);
      } catch (e) {
        return null;
      }
    }

    Future<void> pickImage() {
      return PermissionUtils.storage(
          context: context,
          whenGranted: () async {
            final XFile? pickedFile;
            try {
              pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
              );
            } catch (e) {
              _showSnackBar(context, "gagal memuat gambar");
              return;
            }
            if (pickedFile == null) return;
            String? decodedQr;
            try {
              decodedQr = await parseQRCode(pickedFile.path);
            } catch (e) {
              _showSnackBar(context, "Kode QR Tidak Valid");
              return;
            }

            if (decodedQr!.isEmpty || !decodedQr.contains('LAKUEMAS')) {
              // ignore: use_build_context_synchronously
              _showSnackBar(context, "Kode QR Tidak Valid");
            } else if (decodedQr.isNotEmpty && decodedQr.contains('|')) {
              // ignore: use_build_context_synchronously
              context.goNamed(
                AppRoutes.transfer,
                extra: {
                  // ignore: use_build_context_synchronously
                  'isElite': widget.isElite.toString(),
                  'berandaBalancesBloc': context.read<BerandaBalancesBloc>(),
                  'decodedQr': decodedQr,
                },
              );
            }
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack040,
        centerTitle: true,
        title: Text(
          t.lblTransfer,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: clrWhite,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.beranda);
          },
          color: clrWhite,
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<QrTransferCubit, QrTransferState>(
            buildWhen: (previous, current) =>
                (previous.enQRTransfer != current.enQRTransfer) ||
                (previous.cameraPermission != current.cameraPermission),
            builder: (context, state) {
              if (state.enQRTransfer == EnQRTransfer.scanQR) {
                if (state.cameraPermission == PermissionStatus.granted) {
                  return _buildQrView(context);
                }
                return Container(
                  decoration: BoxDecoration(color: clr000000),
                );
              }
              if (state.enQRTransfer == EnQRTransfer.codeQR) {
                return QRCodeContent(
                  screenshotController: screenshotController,
                );
              }
              return const SizedBox();
            },
          ),
          BlocBuilder<QrTransferCubit, QrTransferState>(
            buildWhen: (previous, current) =>
                (previous.enQRTransfer != current.enQRTransfer),
            builder: (context, state) {
              if (state.enQRTransfer == EnQRTransfer.scanQR) {
                return LayoutBuilder(builder: (context, constraint) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: constraint.maxHeight / 1.2,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Sejajarkan kode QR\ndi dalam bingkai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: clrWhite,
                        ),
                      ),
                    ),
                  );
                });
              }
              return const SizedBox();
            },
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<QrTransferCubit, QrTransferState>(
                    buildWhen: (previous, current) =>
                        (previous.enQRTransfer != current.enQRTransfer),
                    builder: (context, state) {
                      if (state.enQRTransfer == EnQRTransfer.scanQR) {
                        return Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller!.toggleFlash();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: clrYellow,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Flash On',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: clrBackgroundBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    width: double.infinity,
                                    // height: 56,
                                    decoration: BoxDecoration(
                                      color: clrYellow,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Upload QR',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: clrBackgroundBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.enQRTransfer == EnQRTransfer.codeQR) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: MainButton(
                            label: 'Bagikan Kode QR',
                            onPressed: () async {
                              await ShareUtils.shareQrCode(
                                screenshotController: screenshotController,
                                text: 'Kode QR Transfer Saya',
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const TabWidget(),
                ],
              ),
            ),
          ),
          BlocBuilder<QrTransferCubit, QrTransferState>(
            buildWhen: (previous, current) =>
                previous.cameraPermission != current.cameraPermission,
            builder: (context, state) {
              if (state.cameraPermission == PermissionStatus.denied) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: _bannerCameraDenied(
                      text:
                          "Perizinan kamera ditolak.\nTekan tombol disamping untuk minta perizinan kamera.",
                      icon: Icons.refresh,
                      iconOnTap: () {
                        _requestCamera();
                      }),
                );
              }
              if (state.cameraPermission ==
                  PermissionStatus.permanentlyDenied) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: _bannerCameraDenied(
                      text:
                          "Perizinan kamera ditolak. Kamu harus ubah perizinan kamera pada menu pengaturan agar dapat scan QR.\nTekan tombol disamping untuk buka pengaturan.",
                      icon: Icons.settings,
                      iconOnTap: () async {
                        EasyLoading.show();
                        try {
                          await openAppSettings();
                        } catch (e) {
                          EasyLoading.dismiss();
                        }
                        EasyLoading.dismiss();
                      }),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Container _bannerCameraDenied({
    required String text,
    required IconData icon,
    required Function() iconOnTap,
  }) {
    return Container(
      color: clr000000,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: clrRed.withOpacity(0.5),
          border: Border.all(color: clrRed),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: clrWhite),
              ),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: iconOnTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: clrYellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
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
          cutOutBottomOffset: constraint.maxHeight / 10,
        ),
        // onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(_handleScanResult);
  }

  void _handleScanResult(Barcode scanData) {
    setState(() {
      result = scanData;
      if (result!.code!.isEmpty || !result!.code!.contains('LAKUEMAS')) {
        return;
      } else if (result!.code!.isNotEmpty && result!.code!.contains('|')) {
        _navigateToTransfer(context);
      }
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  void _navigateToTransfer(BuildContext context) {
    context.goNamed(
      AppRoutes.transfer,
      extra: {
        'isElite': widget.isElite.toString(),
        'berandaBalancesBloc': context.read<BerandaBalancesBloc>(),
        'dataQr': result!.code,
      },
    );
  }
}
