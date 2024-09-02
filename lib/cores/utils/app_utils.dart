import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../errors/app_failure.dart';

/// unlimited message
appLog(String message) {
  if (kDebugMode) {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        print(message);
      }
    }
    log(message);
  }
}

/// limited message
appPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

appPrintError(String message) {
  if (kDebugMode) {
    print('\x1B[31m$message\x1B[0m');
  }
}

String? errorMessage(AppFailure? appFailure) {
  List errors = (appFailure?.errors?.values ?? []).toList();
  if (errors.isNotEmpty) {
    return errors.join('\n');
  }
  return appFailure?.messages;
}

class AppUtils {
  static Future<bool> phoneCall(String phoneNumb) {
    final uri = Uri(
      scheme: 'tel',
      path: phoneNumb,
    );
    return launchUrl(uri);
  }

  static Future<bool> sendEmailTo(String email) {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    return launchUrl(uri);
  }

  static Future<void> openStore(String? url) async {
    final uri = Uri.tryParse(url ?? "");
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch store';
    }
  }
}

void mainCopyData({
  required BuildContext context,
  required String text,
  String? snackbarText,
}) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackbarText ?? "berhasil disalin"),
      ),
    );
  });
}
