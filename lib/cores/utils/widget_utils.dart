import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_color.dart';
import '../widgets/main_button.dart';

class WidgetUtils {
  static Future<void> showPhoto({
    required BuildContext context,
    required XFile? xFile,
    required String? imageUrl,
    double? imageHeight,
    double? imageWidth,
    double? aspectRatio,
  }) {
    final t = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: context.pop,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            color: clrBlack080.withOpacity(0.85),
            child: Stack(
              children: [
                Center(
                  child: aspectRatio != null
                      ? AspectRatio(
                          aspectRatio: aspectRatio,
                          child: _imageContainer(
                            imageHeight,
                            imageWidth,
                            xFile,
                            imageUrl,
                          ),
                        )
                      : _imageContainer(
                          imageHeight,
                          imageWidth,
                          xFile,
                          imageUrl,
                        ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainButton(
                      label: t.lblBack,
                      bgColor: clrYellow,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  static Container _imageContainer(
      double? imageHeight, double? imageWidth, XFile? xFile, String? imageUrl) {
    return Container(
      height: imageHeight,
      width: imageWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: (xFile?.path ?? '').isEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl ?? ''),
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.center,
              )
            : DecorationImage(
                image: FileImage(
                  File(xFile!.path),
                ),
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.center,
              ),
      ),
    );
  }
}
