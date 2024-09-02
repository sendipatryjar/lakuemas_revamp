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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Environment.flavor = EFlavor.staging;
  if (Platform.isAndroid) {
    await AppCenter.start(secret: '811910df-c687-4951-9e71-cae64bbd31d4');
  }
  if (Platform.isIOS) {
    await AppCenter.start(secret: '85948b07-2ccd-4ee9-bec2-4047530766fa');
  }
  await Firebase.initializeApp(name: 'staging', options: Environment.firebaseOptions());
  FlutterLocalNotificationService.init();
  FirebaseMessagingService.init();
  await Future.wait([
    if (!kIsWeb) ...[
      AppCenterAnalytics.enableManualSessionTracker(),
      AppCenterAnalytics.startSession(),
    ],
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    di.init(),
  ]);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    if (!kIsWeb) {
      AppCenterCrashes.trackException(
        message: '${errorDetails.exception}',
        type: errorDetails.exception.runtimeType,
        stackTrace: errorDetails.stack,
      );
    }
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      // fatal: true,
    );
    if (!kIsWeb) {
      AppCenterCrashes.trackException(
        message: '$error',
        type: error.runtimeType,
        stackTrace: stack,
      );
    }
    return true;
  };
  configLoading();
  final initialRoute = await AppRoutes.initialRoute;
  if (kIsWeb) usePathUrlStrategy();
  runApp(RequestsInspector(
    enabled: true,
    showInspectorOn: ShowInspectorOn.Shaking,
    // hideInspectorBanner: true,
    child: App(
      initialRoute: initialRoute,
    ),
  ));
}
