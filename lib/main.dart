import 'dart:io';

import 'package:appcenter_sdk_flutter/appcenter_sdk_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'cores/configs/environment.dart';
import 'cores/constants/app_color.dart';
import 'cores/routes/app_routes.dart';
import 'cores/services/firebase/firebase_messaging_service.dart';
import 'cores/services/flutter_local_notification_service.dart';
import 'features/app.dart';
import 'cores/depedencies_injection/depedency_injection.dart' as di;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Environment.flavor = EFlavor.prod;
  await Environment.appcenter();
  await Firebase.initializeApp(
      name: 'production', options: Environment.firebaseOptions());
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
    child: App(
      initialRoute: initialRoute,
    ),
  ));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..lineWidth = 1
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = false
    ..textColor = clrBackgroundBlack
    ..progressColor = clrNeutralGrey999
    ..backgroundColor = clrWhite
    ..indicatorColor = clrYellow
    ..maskColor = clrYellow
    ..maskType = EasyLoadingMaskType.black
    ..errorWidget = Icon(
      Icons.clear,
      color: clrRed,
      size: EasyLoading.instance.indicatorSize,
    )
    ..userInteractions = false;
  // ..textStyle = TextStyle(
  //   fontSize: 15,
  //   fontWeight: fontWeightMedium,
  //   fontFamily: 'Poppins',
  // );
}
