import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../../../../cores/constants/img_assets.dart';
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as web;

import '../constants/app_color.dart';
import '../utils/app_utils.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FlutterLocalNotificationService {
  static bool _isWeb = false;
  static bool isFlutterLocalNotificationsInitialized = false;
  static AndroidNotificationChannel? channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static Future<void> init({bool isWeb = false}) async {
    _isWeb = isWeb;
    if (isWeb) {
      // var permission = web.Notification.permission;
      // if (permission != 'granted') {
      //   permission = await web.Notification.requestPermission();
      // }
      // appPrint('web notif permission: $permission');
      return;
    }

    bool? isPermissionGranted = false;
    if (Platform.isAndroid) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
    if (Platform.isIOS) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (isPermissionGranted == true) {
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          appPrint(
              '[FlutterLocalNotificationService][init] DarwinInitializationSettings onDidReceiveLocalNotification: $payload');
        },
      );
      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          appPrint(
              '[FlutterLocalNotificationService][init] onDidReceiveNotificationResponse: ${details.toString()}');
        },
        onDidReceiveBackgroundNotificationResponse: _backgroundHandler,
      );
    }
    // else {
    //   await init();
    // }
  }

  static Future<void> setupFlutterNotifications() => init();

  static void _backgroundHandler(NotificationResponse details) {
    appPrint(
        '[FlutterLocalNotificationService][_backgroundHandler] onDidReceiveBackgroundNotificationResponse: ${details.toString()}');
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    if (notification != null /*&& android != null*/ && !_isWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel?.id ?? '',
            channel?.name ?? '',
            channelDescription: channel?.description,
            icon: '@drawable/ic_notification',
            color: clrYellow,
            styleInformation: const BigTextStyleInformation(''),
          ),
          iOS: const DarwinNotificationDetails(
            presentSound: true,
            presentAlert: true,
          ),
        ),
      );
    }
    if (notification != null && _isWeb) {
      // web.Notification(
      //   notification.title ?? 'web notification',
      //   body: notification.body,
      //   icon: icLauncher,
      // );
    }
  }
}
