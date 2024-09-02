import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../constants/app_color.dart';
import 'idcard_overlay_shape.dart';
import 'overlay_model.dart';

typedef XFileCallback = void Function(XFile file);

class IdCardCameraOverlay extends StatefulWidget {
  final CameraDescription camera;
  final OverlayModel model;
  final bool flash;
  final bool enableCaptureButton;
  final XFileCallback onCapture;
  final String? info;
  final Widget? loadingWidget;
  final EdgeInsets? infoMargin;
  const IdCardCameraOverlay({
    Key? key,
    required this.camera,
    required this.model,
    required this.onCapture,
    this.flash = false,
    this.enableCaptureButton = true,
    this.info,
    this.loadingWidget,
    this.infoMargin,
  }) : super(key: key);

  @override
  State<IdCardCameraOverlay> createState() => _IdCardCameraOverlayState();
}

class _IdCardCameraOverlayState extends State<IdCardCameraOverlay> {
  _IdCardCameraOverlayState();

  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max,
        enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('loading camera'),
          ),
        );

    if (!controller.value.isInitialized) {
      return loadingWidget;
    }

    controller
        .setFlashMode(widget.flash == true ? FlashMode.auto : FlashMode.off);

    var camera = controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: scale,
          child: Center(child: CameraPreview(controller)),
        ),
        IdCardOverlayShape(widget.model),
        if (widget.info != null)
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.info!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: clrWhite.withOpacity(0.75),
                ),
              ),
            ),
          ),
        if (widget.enableCaptureButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: clrBackgroundBlack,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      EasyLoading.show();
                      for (int i = 10; i > 0; i--) {
                        await HapticFeedback.vibrate();
                      }

                      XFile file = await controller.takePicture();
                      EasyLoading.dismiss();
                      widget.onCapture(file);
                    },
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            size: 70,
                            color: clrWhite,
                          ),
                          Icon(
                            Icons.circle,
                            size: 48,
                            color: clrWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
    // return Column(
    //   children: [
    //     Expanded(
    //       child: Stack(
    //         alignment: Alignment.bottomCenter,
    //         fit: StackFit.expand,
    //         children: [
    //           CameraPreview(controller),
    //           IdCardOverlayShape(widget.model),
    //           if (widget.info != null)
    //             Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                   padding: const EdgeInsets.symmetric(horizontal: 20),
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Flexible(
    //                         child: Text(
    //                           widget.info!,
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                               fontSize: 12,
    //                               fontWeight: FontWeight.w500,
    //                               color: clrWhite.withOpacity(0.75)),
    //                         ),
    //                       ),
    //                       const SizedBox(height: 24),
    //                     ],
    //                   )),
    //             ),
    //         ],
    //       ),
    //     ),
    //     if (widget.enableCaptureButton)
    //       Container(
    //         padding: const EdgeInsets.all(20),
    //         decoration: BoxDecoration(
    //           color: clrBackgroundBlack,
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             Icon(
    //               Icons.circle_outlined,
    //               size: 45,
    //               color: clrWhite,
    //             ),
    //             GestureDetector(
    //               onTap: () async {
    //                 for (int i = 10; i > 0; i--) {
    //                   await HapticFeedback.vibrate();
    //                 }

    //                 XFile file = await controller.takePicture();
    //                 widget.onCapture(file);
    //               },
    //               child: SizedBox(
    //                 height: 75,
    //                 width: 75,
    //                 child: Stack(
    //                   fit: StackFit.expand,
    //                   alignment: Alignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.circle_outlined,
    //                       size: 70,
    //                       color: clrWhite,
    //                     ),
    //                     Icon(
    //                       Icons.circle,
    //                       size: 48,
    //                       color: clrWhite,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Icon(
    //               Icons.change_circle_outlined,
    //               size: 45,
    //               color: clrWhite,
    //             ),
    //           ],
    //         ),
    //       ),
    //   ],
    // );
  }
}
