import 'dart:io';

import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options/firebase_options_dev.dart' as firebase_dev;
import '../../firebase_options/firebase_options_staging.dart'
    as firebase_staging;
import '../../firebase_options/firebase_options_prod.dart' as firebase_prod;

enum EFlavor { dev, staging, prod }

class Environment {
  static EFlavor flavor = EFlavor.dev;

  static String baseUrlMember() {
    switch (flavor) {
      case EFlavor.dev:
        return 'http://192.168.10.5:8082';
      case EFlavor.staging:
        return 'https://go-dev.lakuemas.com/user';
      case EFlavor.prod:
        return 'https://go-prod.lakuemas.com/user';
      default:
        return '';
    }
  }

  static String baseUrlGundala() {
    switch (flavor) {
      case EFlavor.dev:
        return 'http://192.168.10.5:8083';
      case EFlavor.staging:
        return 'https://go-dev.lakuemas.com/inventory';
      case EFlavor.prod:
        return 'https://go-prod.lakuemas.com/inventory';
      default:
        return '';
    }
  }

  static String baseUrlTransaction() {
    switch (flavor) {
      case EFlavor.dev:
        return 'http://192.168.10.5:8084';
      case EFlavor.staging:
        return 'https://go-dev.lakuemas.com/transaction';
      case EFlavor.prod:
        return 'https://go-prod.lakuemas.com/transaction';
      default:
        return '';
    }
  }

  static String baseUrlInternalProcessService() {
    switch (flavor) {
      case EFlavor.dev:
        return 'http://192.168.10.5:8085';
      case EFlavor.staging:
        return 'https://go-dev.lakuemas.com/internal';
      case EFlavor.prod:
        return 'https://go-prod.lakuemas.com/internal';
      default:
        return '';
    }
  }

  static String baseUrlDice() {
    switch (flavor) {
      case EFlavor.dev:
        return 'http://192.168.10.5:8073/lakuemas-service-dice/public/';
      case EFlavor.staging:
        return 'https://go-dev.lakuemas.com/dice/';
      case EFlavor.prod:
        return 'https://go-prod.lakuemas.com/dice/';
      default:
        return '';
    }
  }

  static FirebaseOptions? firebaseOptions() {
    switch (flavor) {
      case EFlavor.dev:
        return firebase_dev.DefaultFirebaseOptions.currentPlatform;
      case EFlavor.staging:
        return firebase_staging.DefaultFirebaseOptions.currentPlatform;
      case EFlavor.prod:
        return firebase_prod.DefaultFirebaseOptions.currentPlatform;
      default:
        return firebase_dev.DefaultFirebaseOptions.currentPlatform;
    }
  }

  static String firebaseVapidKeyForWeb() {
    switch (flavor) {
      case EFlavor.dev:
        return 'BFFX3bWZTekz93QtkCj6Bt4lmummG1ilTB0M8mre9NbtA5cO27vimIZiwE5VpHWeHkCcd42NdlYsOXJX4XF1V08';
      case EFlavor.staging:
        return 'BEtk6rRlh98Fd9t2UKGDWXvAiX5FfADGvAM2Ctrwot-0lG5IM-qXKGbpe5bjQOWUdswWw2ES177GMexGa6X6JOY';
      case EFlavor.prod:
        return 'BN_4Uk8V8UWmNmvE6HCoakpUiRsBl16E9bDPEGVpDF97fiE-ZvRgt24f_veV7SENugmPVgwzcG_xzrXAFhqq2Kk';
      default:
        return '';
    }
  }

  static Future<void>? appcenter() {
    switch (flavor) {
      case EFlavor.dev:
        if (!kIsWeb || Platform.isAndroid) {
          return AppCenter.start(
              secret: '811910df-c687-4951-9e71-cae64bbd31d4');
        }
      case EFlavor.staging:
        if (Platform.isAndroid) {
          return AppCenter.start(
              secret: '811910df-c687-4951-9e71-cae64bbd31d4');
        }
        if (Platform.isIOS) {
          return AppCenter.start(
              secret: '85948b07-2ccd-4ee9-bec2-4047530766fa');
        }
      case EFlavor.prod:
        if (Platform.isAndroid) {
          return AppCenter.start(
              secret: 'a9106cbc-3c72-4830-a609-bf7da1488bc5');
        }
        if (Platform.isIOS) {
          return AppCenter.start(
              secret: '85948b07-2ccd-4ee9-bec2-4047530766fa');
        }
    }
    return null;
  }

  static String readyPlayerMeBaseUrl(String? partner) {
    if (partner != null) {
      return 'https://$partner.readyplayer.me';
    }
    return 'https://api.readyplayer.me';
  }
}
