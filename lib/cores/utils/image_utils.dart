import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'app_utils.dart';
import 'permissions_utils.dart';

class MainImageUtils {
  static Future<File> base64ToFile({required String base64}) async {
    var base64Splited = base64.split(",");
    Uint8List bytes = base64Decode(base64Splited.last);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> imageUrlToFile({required String url}) async {
    /// Get Image from server
    final Response res = await Dio().get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    /// Get App local storage
    final Directory appDir = await getApplicationDocumentsDirectory();

    /// Generate Image Name
    final String imageName = url.split('/').last;

    /// Create Empty File in app dir & fill with new image
    final File file = File(join(appDir.path, imageName));

    file.writeAsBytesSync(res.data as List<int>);

    return file;
  }

  static void downloadImageDio({
    required BuildContext context,
    required String url,
    String? path = '',
    String? filename,
    Function()? onSuccess,
    Function(dynamic)? onFailed,
  }) async {
    PermissionUtils.storage(
        context: context,
        whenGranted: () async {
          try {
            EasyLoading.show();
            var dateNow = DateTime.now();
            var dateFortmatedStr = DateFormat('yyyyMMddhhmmss').format(dateNow);
            var directory =
                await MainImageUtils.getLocalDirectory(lastPath: '$path${filename ?? dateFortmatedStr}.jpg');

            // await Dio().download(url, directory);
            Dio().download(url, directory).then((value) async {
              try {
                await ImageGallerySaver.saveFile(directory ?? dateFortmatedStr, isReturnPathOfIOS: true);
                EasyLoading.dismiss();
                appPrint('[downloadImage] download success. directory: $directory');
                if (onSuccess != null) onSuccess();
              } catch (e) {
                EasyLoading.dismiss();
                appPrintError('download qris to local failed: $e');
                if (onFailed != null) onFailed(e);
              }
            }).catchError((error) {
              EasyLoading.dismiss();
              appPrintError('[downloadImageDio] download qris from url failed: $error');
              if (onFailed != null) onFailed(error);
            });
          } catch (e) {
            EasyLoading.dismiss();
            appPrintError('download qris from url failed: $e');
            if (onFailed != null) onFailed(e);
          }
        });

    // EasyLoading.show();
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.storage,
    //   Permission.manageExternalStorage,
    // ].request();
    // var storage = statuses[Permission.storage];
    // var manageExternalStorage = statuses[Permission.manageExternalStorage];

    // if ((storage?.isPermanentlyDenied ?? false) || (manageExternalStorage?.isPermanentlyDenied ?? false)) {
    //   onPermissionPermanentDenied();
    //   EasyLoading.dismiss();
    //   return;
    // }

    // if ((storage?.isGranted ?? false) || (manageExternalStorage?.isGranted ?? false)) {
    //   try {
    //     var dateNow = DateTime.now();
    //     var dateFortmatedStr = DateFormat('yyyyMMddhhmmss').format(dateNow);
    //     var directory = await MainImageUtils.getLocalDirectory(lastPath: '$path${filename ?? dateFortmatedStr}.jpg');

    //     // await Dio().download(url, directory);
    //     Dio().download(url, directory).then((value) async {
    //       try {
    //         await ImageGallerySaver.saveFile(directory ?? dateFortmatedStr, isReturnPathOfIOS: true);
    //         EasyLoading.dismiss();
    //         appPrint('[downloadImage] download success. directory: $directory');
    //         if (onSuccess != null) onSuccess();
    //       } catch (e) {
    //         EasyLoading.dismiss();
    //         appPrintError('download qris to local failed: $e');
    //         if (onFailed != null) onFailed(e);
    //       }
    //     }).catchError((error) {
    //       EasyLoading.dismiss();
    //       appPrintError('[downloadImageDio] download qris from url failed: $error');
    //       if (onFailed != null) onFailed(error);
    //     });
    //   } catch (e) {
    //     EasyLoading.dismiss();
    //     appPrintError('download qris from url failed: $e');
    //     if (onFailed != null) onFailed(e);
    //   }
    // } else {
    //   EasyLoading.dismiss();
    // }
  }

  static Future<String?> getLocalDirectory({required String lastPath}) async {
    var localDir = await _findLocalPath(lastPath);
    appPrint('local derectory: $localDir');
    if (localDir != null) {
      var savedDir = Directory(localDir);
      // bool hasExisted = await savedDir.exists();
      // if (!hasExisted) {
      //   savedDir = await savedDir.create();
      // }
      return savedDir.path;
    }
    return localDir;
  }

  static Future<String?> _findLocalPath(String lastPath) async {
    Directory? directory;
    if (Platform.isIOS) {
      // directory = await getDownloadsDirectory();
      directory = await getTemporaryDirectory();
    } else {
      String? directoryStr = "/storage/emulated/0/Download/";
      bool isDirectoryExist = await Directory(directoryStr).exists();
      if (isDirectoryExist) {
        directoryStr = "/storage/emulated/0/Download/";
      } else {
        directoryStr = "/storage/emulated/0/Downloads/";
      }

      directory = Directory(directoryStr);
    }
    return '${directory.path}${Platform.pathSeparator}$lastPath';
  }
}
