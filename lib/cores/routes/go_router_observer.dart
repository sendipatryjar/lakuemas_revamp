import 'package:flutter/material.dart';

import '../utils/app_utils.dart';
import 'app_routes.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    appPrint('Pushed route: ${route.str}'); //name comes back null
    if (previousRoute != null) {
      appPrint('previousRoute: ${previousRoute.str}');
    }
    appPrint('=====');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    appPrint('Poped route: ${route.str}'); //name comes back null
    if (previousRoute != null) {
      appPrint('previousRoute: ${previousRoute.str}');
    }
    appPrint('=====');
    if (route.settings.name == AppRoutes.lakuTradeDetail) {
      onLakuTradeDetailPoped();
    }
    if (route.settings.name == AppRoutes.lakuSaveDetail &&
        previousRoute?.settings.name == AppRoutes.lakuSave) {
      onLakuSaveSuccess();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    appPrint('Removed route: ${route.str}'); //name comes back null
    if (previousRoute != null) {
      appPrint('previousRoute: ${previousRoute.str}');
    }
    appPrint('=====');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    appPrint('Replaced newRoute: ${newRoute!.str}');
    appPrint('oldRoute: ${oldRoute!.str}'); //n//name comes back null
    appPrint('=====');
  }
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}

Function() onLakuTradeDetailPoped = () {};
Function() onLakuSaveSuccess = () {};
