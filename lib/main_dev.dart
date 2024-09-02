// import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';
import 'dart:io';

import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'cores/configs/environment.dart';
import 'cores/routes/app_routes.dart';
import 'cores/services/firebase/firebase_messaging_service.dart';
import 'cores/services/flutter_local_notification_service.dart';
import 'features/app.dart';
import 'cores/depedencies_injection/depedency_injection.dart' as di;
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment.flavor = EFlavor.dev;
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      await AppCenter.start(secret: '811910df-c687-4951-9e71-cae64bbd31d4');
      await Future.wait([
        AppCenterAnalytics.enableManualSessionTracker(),
        AppCenterAnalytics.startSession(),
      ]);
    }
  }
  await Firebase.initializeApp(
    name: kIsWeb ? null : 'dev',
    options: Environment.firebaseOptions(),
  );
  FlutterLocalNotificationService.init(isWeb: kIsWeb);
  FirebaseMessagingService.init(isWeb: kIsWeb);
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    di.init(),
  ]);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        AppCenterCrashes.trackException(
          message: '${errorDetails.exception}',
          type: errorDetails.exception.runtimeType,
          stackTrace: errorDetails.stack,
        );
      }
    }
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        AppCenterCrashes.trackException(
          message: '$error',
          type: error.runtimeType,
          stackTrace: stack,
        );
      }
    }
    return true;
  };
  configLoading();
  final initialRoute = await AppRoutes.initialRoute;
  if (kIsWeb) usePathUrlStrategy();
  runApp(RequestsInspector(
    enabled: true,
    hideInspectorBanner: false,
    child: App(
      initialRoute: initialRoute,
    ),
  ));
}
