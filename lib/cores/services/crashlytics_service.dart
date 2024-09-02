// import 'package:app_center_bundle_sdk/app_center_bundle_sdk.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticService {
  static void sendErrorGeneral({
    required dynamic exception,
    required StackTrace stackTrace,
  }) async {
    await _sendErrorToCloud(
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  static void sendErrorApi({
    required dynamic exception,
    required StackTrace stackTrace,
    required String url,
    required String method,
    required String header,
    required String request,
  }) async {
    await _sendErrorToCloud(
      exception: exception,
      stackTrace: stackTrace,
      information: [
        'URL : $url',
        'Method : $method',
        'Header : $header',
        'Request : $request',
      ],
    );
  }

  static Future _sendErrorToCloud({
    required dynamic exception,
    required StackTrace stackTrace,
    Iterable<Object> information = const [],
  }) async {
    // await FirebaseCrashlytics.instance.recordError(exception, stackTrace,
    //     fatal: false, information: information, reason: reason);
    // await AppCenter.trackEventAsync(
    //     '$exception: $stackTrace', Map.fromIterable(information));
  }
}
