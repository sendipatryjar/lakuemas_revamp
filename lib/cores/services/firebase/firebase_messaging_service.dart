import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../features/_core/user/data/models/user_data_model.dart';
import '../../configs/environment.dart';
import '../../constants/secure_storage_key.dart';
import '../../depedencies_injection/depedency_injection.dart';
import '../../utils/app_utils.dart';
import '../flutter_local_notification_service.dart';
import '../secure_storage_service.dart';

class FirebaseMessagingService {
  static String? token;
  static FirebaseMessaging? messaging;

  static Future<void> init({bool isWeb = false}) async {
    messaging = FirebaseMessaging.instance;

    var appPermission = await messaging?.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true);
    appPrint(
        '[FirebaseMessagingService][init] User granted permission: ${appPermission?.authorizationStatus}');

    token = isWeb
        ? await messaging?.getToken(
            vapidKey: Environment.firebaseVapidKeyForWeb(),
          )
        : await messaging?.getToken();
    appPrint('[FirebaseMessagingService][init] fcm token: $token');
    messaging?.onTokenRefresh.listen(
      (fcmToken) {
        appPrint(
          '[FirebaseMessagingService][init] fcm token has been updated from $token to $fcmToken',
        );
        token = fcmToken;
      },
    ).onError(
      (err) {
        appPrint('[FirebaseMessagingService][init] error getting token');
      },
    );

    if (appPermission?.authorizationStatus == AuthorizationStatus.authorized) {
      await messaging?.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      await _setupInteractedMessage(isWeb: isWeb);
    }

    if (!isWeb) {
      subscribeTopics();
    }
  }

  static Future<void> _setupInteractedMessage({bool isWeb = false}) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      appPrint(
          '[FirebaseMessagingService][_setupInteractedMessage] onMessage.listen: Got a message whilst in the foreground!');
      appPrint(
          '[FirebaseMessagingService][_setupInteractedMessage] onMessage.listen: Message data: ${message.data}');
      if (message.notification != null) {
        appPrint(
            '[FirebaseMessagingService][_setupInteractedMessage] onMessage.listen: Message also contained a notification: ${message.notification?.toMap()}');
      }
      if (!isWeb) {
        if (Platform.isIOS) {
          return;
        }
      }
      FlutterLocalNotificationService.showFlutterNotification(message);
    });
  }

  static void _handleOpenedMessage(RemoteMessage message) {
    appPrint(
        '[FirebaseMessagingService][_handleOpenedMessage] remote message: ${message.toMap()}');
  }

  static void _handleMessage(RemoteMessage message) {
    appPrint(
        '[FirebaseMessagingService][_handleMessage] remote message: ${message.toMap()}');
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // await Firebase.initializeApp(options: Environment.firebaseOptions());
    // await FlutterLocalNotificationService.setupFlutterNotifications();
    // FlutterLocalNotificationService.showFlutterNotification(message);
    // _handleMessage(message);
    appPrint(
        '[FirebaseMessagingService][_firebaseMessagingBackgroundHandler] Handling a background message ${message.messageId}');
  }

  static void subscribeTopics({
    final bool? subscribePricing,
    final bool? subscribePromo,
  }) async {
    if (subscribePricing == null && subscribePromo == null) {
      final userMapString =
          await sl<SecureStorageService>().readSecureData(ssUserData);
      final user = UserDataModel.fromJson(jsonDecode(userMapString ?? '{}'));
      _subscribeTopics(
          name: 'pricing', value: user.userSettingEntity?.withPrice);
      _subscribeTopics(name: 'promo', value: user.userSettingEntity?.withPromo);
      return;
    }
    _subscribeTopics(name: 'pricing', value: subscribePricing);
    _subscribeTopics(name: 'promo', value: subscribePromo);
  }

  static void _subscribeTopics({required String name, bool? value}) {
    if (value == true) {
      messaging?.subscribeToTopic(name).then((value) {
        appPrint('subscribeToTopic: $name');
      });
    } else {
      messaging?.unsubscribeFromTopic(name).then((value) {
        appPrint('unsubscribeFromTopic: $name');
      });
    }
  }
}
