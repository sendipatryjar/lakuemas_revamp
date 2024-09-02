import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/img_assets.dart';
import 'dialog_utils.dart';

class PermissionUtils {
  static Future<void> storage(
      {required BuildContext context, required Function() whenGranted}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    var storage = statuses[Permission.storage];
    var manageExternalStorage = statuses[Permission.manageExternalStorage];

    if ((storage?.isGranted ?? false) ||
        (manageExternalStorage?.isGranted ?? false)) {
      whenGranted();
    } else if ((storage?.isPermanentlyDenied ?? false) ||
        (manageExternalStorage?.isPermanentlyDenied ?? false)) {
      // ignore: use_build_context_synchronously
      DialogUtils.universal(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: true,
        icon: Image.asset(icWarningYellow),
        firstDesc: 'Perizinan Storage',
        secondDesc:
            'Mohon untuk aktifkan perizinan pada menu Settings di ponsel anda',
        btnText: 'Buka Settings',
        btnConfirm: () => openAppSettings(),
      );
    }
  }
}
