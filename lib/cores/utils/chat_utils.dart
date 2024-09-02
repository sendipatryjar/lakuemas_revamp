import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatUtils {
  static Future<void> chatWhatsapp({
    required String phoneNumber,
    String? message,
    required BuildContext context,
  }) async {
    // var whatsappUrl = Uri.parse("whatsapp://send?phone=$phoneNumber");
    var whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.tryParse('')}");
    if (Platform.isAndroid) {
      whatsappUrl = Uri.parse("whatsapp://send?phone=$phoneNumber");
    }

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("WhatsApp is not installed on this device"),
        ),
      );
    }
  }
}
