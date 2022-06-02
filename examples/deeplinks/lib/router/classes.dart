import 'package:deeplinks/home_page.dart';
import 'package:deeplinks/router/locations/deeplink_location.dart';
import 'package:deeplinks/router/locations/home_location.dart';
import 'package:deeplinks/router/locations/page1_location.dart';
import 'package:deeplinks/router/locations/page2_location.dart';
import 'package:deeplinks/router/locations/page3_location.dart';
import 'package:flutter/material.dart';
import 'package:hopper/hopper.dart';

class AppRouter extends AbstractAppRouter {
  final GlobalKey<NavigatorState> navigatorKey;
  static const String initialRoute = '/';

  AppRouter()
      : navigatorKey = GlobalKey<NavigatorState>(),
        super((AbstractAppRouter appRouter) => AppNavigationManager(appRouter));
}

class AppNavigationManager extends AbstractAppNavigationManager {
  final AbstractAppRouter routerDelegate;

  AppNavigationManager(this.routerDelegate) : super(routerDelegate);

  @override
  List<AppLocation> get locations => [
    HomeLocation(),
    Page1Location(),
    Page2Location(),
    Page3Location(),
    DeeplinkLocation(),
  ];
}

