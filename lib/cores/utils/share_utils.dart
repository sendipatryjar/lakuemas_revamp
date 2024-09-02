import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'app_utils.dart';

class ShareUtils {
  static Future<File?> _urlToFile(String imageUrl) async {
    var dio = Dio();
    var rng = Random();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    File file = File('$tempPath/${rng.nextInt(1000000000)}.jpg');

    try {
      Response response = await dio.get(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      await file.writeAsBytes(response.data);
      return file;
    } catch (e) {
      // Handle any Dio errors here
      appPrint('Error downloading image: $e');
      return null;
    }
  }

  static Future<void> share({
    required BuildContext context,
    String? imgUrl,
    required String text,
  }) async {
    EasyLoading.show();
    final box = context.findRenderObject() as RenderBox?;

    var imageUrl =
        (imgUrl ?? '').isEmpty ? null : await _urlToFile(imgUrl ?? '');

    EasyLoading.dismiss();

    if (imageUrl != null) {
      final files = <XFile>[];

      files.add(XFile(imageUrl.path, name: imageUrl.path));

      await Share.shareXFiles(
        files,
        text: text,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } else {
      await Share.share(
        text,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  static Future<void> shareQrCode({
    required ScreenshotController screenshotController,
    required String text,
  }) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.jpg').create();
          final files = <XFile>[];

          files.add(XFile(imagePath.path));
          await imagePath.writeAsBytes(image);

          if (Platform.isAndroid) {
            Share.shareXFiles(files, text: text);
          } else {
            Share.shareXFiles(files);
          }
        } catch (error) {
          appPrint('Error --->> $error');
        }
      }
    }).catchError((onError) {
      appPrint('Error --->> $onError');
    });
  }
}
